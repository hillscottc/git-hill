#! /usr/bin/python
"""Handles database connection strings in files using DbProfiles.

Usage: go() is the main function. Many examples in tests below.
>>> cm = ConfigMgr(dbsource='input/DbSet.data.csv', path='input/ETL/MP/UMG.RDx.ETL.MP.vshost.exe.config')
>>> match_dict = cm.go(verbose=False)
>>> print ConfigMgr.match_dict_summary(match_dict)
Found 4 matches in 1 of 1 files scanned.
"""
import sys
import re
import os
from DbSet import DbSet
from ConnMatchInfo import ConnMatchInfo
from DbProfile import DbProfile
#from MatchSet import MatchSet



class ConfigMgr(object):
    """Handles database connection strings in files using DbProfiles.
    """
    #REGEX = 'Data Source=(Usfshwssql\w+);Initial Catalog=(RDx\w+);'
    #REGEX = 'Data Source=([\w\\\]+);Initial Catalog=(RDx\w+);'
    REGEX = 'Data Source=(.+);Initial Catalog=(RDx\w+);'
    WORK_DIR = 'work'
    OUTPUT_DIR = 'output'
    
    def __init__(self, dbsource=None, path=None, env=None, write=False, verbose=True):
        if dbsource: self.dbsource = dbsource
        if path: self.path = path
        self.env = env
        self.write = write
        self.verbose = verbose
        

    def set_path(self, value):
        if not self.dbset: raise Exception('dbset is required when setting path.')
        self.filelist = ConfigMgr.get_filelist(value)
        #print 'Set path to ' + value
        self._path = value

    def get_path(self):
        return self._path

    path = property(get_path, set_path)
    
    
    def set_dbsource(self, value):
        self._dbsource = value
        self.dbset = DbSet(cvsfile=value)

    def get_dbsource(self):
        return self._dbsource

    dbsource = property(get_dbsource, set_dbsource)
    

    @staticmethod
    def get_filelist(path=None, skipdir='Common'):
        """Gets config files in given path. Walks ssubdirs.
        Skips dirs named <skipdir>..

        Usage:  
        >>> path = 'input/ETL/'
        >>> filelist = ConfigMgr.get_filelist(path)
        >>> print '{} files are in path {}'.format(len(filelist), path)
        22 files are in path input/ETL/
        """
        if not path: raise Exception('path is required for get_filelist.')
        filelist = []
        
        if os.path.isfile(path) :
            filelist.append(path)
        elif os.path.isdir(path) :
            for root, dirs, files in os.walk(path):
                if skipdir in dirs:
                    dirs.remove(skipdir)
                for name in files:
                    filepathname = os.path.join(root, name)
                    ext = os.path.splitext(filepathname)[1]
                    if ext == '.config':
                        filelist.append(filepathname)
        else: 
            msg = path  + ' does not exist.'
            raise Exception(msg)
        return filelist


    @staticmethod
    def trim_line(self, longline, max_length=80, chars_trimmed=20, chars_shown=65):
        """Returns a block from the middle of the line, with ellipsis."""
        shortline = longline.strip()
        if len(shortline) > chars_shown and len(shortline) > chars_trimmed :
            shortline = '...' + shortline[chars_trimmed : chars_trimmed+chars_shown] + '...'
        return shortline

    @staticmethod
    def get_output_filename(infilename):
        """ Returns path to ./outdir/filename. Creates if necc."""
        outfilename = re.sub(ConfigMgr.WORK_DIR, ConfigMgr.OUTPUT_DIR, infilename)
        ConfigMgr.ensure_dir(outfilename)
        return outfilename

    @staticmethod
    def ensure_dir(f):
        """ Creates the dirs to f if they don't already exist. """
        d = os.path.dirname(f)
        if not os.path.exists(d):
            os.makedirs(d)
        

    # THESE MD STATICS SHOULD BELONG TO A CLASS
    @staticmethod
    def get_match_files(md, with_matches=True):
        """ Returns files with or without matches.
        """
        if with_matches:
            return [k for k, v in md.iteritems() if len(v) > 1]
        else:
            return [k for k, v in md.iteritems() if len(v) == 0]


    @staticmethod
    def match_dict_summary(md):
        """Usage:
        >>> cm = ConfigMgr(dbsource='input/DbSet.data.csv', path='input/ETL/')
        >>> print ConfigMgr.match_dict_summary(cm.go(verbose=False))
        Found 23 matches in 8 of 22 files scanned.
        """
        return 'Found {} matches in {} of {} files scanned.'.format\
            (sum([len(v) for v in md.values()]),
             len([k for k, v in md.iteritems() if len(v) > 1]),
             len(md.keys())
            )


    def go(self, filelist=None, app=None, env=None, write=False, verbose=True) :
        """Checks file for lines which contain connection string information,
        for each file in filelist.
            
        Usage:
        >>> cm = ConfigMgr(dbsource='input/DbSet.data.csv', path='input/ETL/MP/')
        >>> print ConfigMgr.match_dict_summary(cm.go(verbose=False))
        Found 4 matches in 1 of 4 files scanned.
        """
        
        if not filelist:
            filelist = self.filelist
        if not filelist:
            raise Exception('filelist required.')
        
        if write:
#            if not env:
#                env = self.env
            if not env :
                raise Exception('env is required for write.')

        if app:
            apps = [app]
        else:
            apps = DbSet.APPS
            
        match_dict = {}
        #match_dict = MatchSet()
        match_msgs = []
        
        match_msgs.append("Checking filelist for env: {}, apps: {} ".format(env, apps))
        
        for filename in filelist:            
            
            
            # skip file if it doesnt have one of the apps in its name
            if not len([app for app in apps if re.search(app, filename)]) :
                continue
                
            #if not re.search(app, filename):
            #    continue

            if write: outfilename = self.get_output_filename(filename)
            
            match_msgs.append('In file {}:'.format(filename))

            # read all lines of file into var
            with open(filename, 'r') as infile:
                lines = infile.readlines()

            cmiList = []
            linenum = 0
            outlines = ''

            # check lines
            for line in lines:
                linenum = linenum +1
                
                dbset_matches = []
                
                # print 'line {}:{}    {}'.format(str(linenum), os.linesep, self.trim_line(line))
                m = re.search(self.REGEX, line, re.IGNORECASE)
                if m:
                    m_boxname, m_dbname = m.group(1), m.group(2)
                    ci = ConnMatchInfo(m_boxname, m_dbname, linenum)
                    cmiList.append(ci)

                    
                    for app in apps:
                        if re.search(app, filename):
                            profDict = dict(boxname=ci.boxname.lower(), dbname=ci.dbname, env=env, app=app)
                            #print 'CHECK THIS', profDict
                            profs = self.dbset.get_profiles_by_attribs(profDict)
                            if profs:
                                dbset_matches.append (profs)


                    match_msgs.append('  {} matched {} from the dbset.'.format(ci, dbset_matches))
                    #print 'len of dbset_matches is {}'.format(len(dbset_matches))
                    if not dbset_matches:
                        db_sugestions = []
                                    
                        #print 'APPPPPP', [app for app in apps if re.search(app, filename)][0], filename
                        
                        app_to_check = [app for app in apps if re.search(app, filename)][0]
                        
                        profs = self.dbset.get_profiles_by_attribs(dict(dbname=ci.dbname,
                                                                        app=app_to_check,
                                                                        env=env))
                        #print 'GOT', profs, 'for' , filename, ci.dbname, app_to_check, env
                        
                        if profs:
                            db_sugestions.append(profs)
                            match_msgs.append('    * dbset profile for {} - {} is {}'.format(app_to_check, env, db_sugestions))
                        else:
                            match_msgs.append('    ********** No suggestions for {} - {}'.format(app_to_check, env))
                            
                        #db_sugestions = self.dbset.get_profiles_by_attribs(dict(dbname=ci.dbname, app=app, env=env))
                        
#                        for dbprof in db_sugestions:
#                            match_msgs.append('    * dbset profile for {}/{} is {}'.format(app, env, dbprof))
                        
                        #print 'db_sugestions is {}'.format(db_sugestions)
                        
                        if write and db_sugestions:
                            #print 'db_sugestions[0]===', db_sugestions[0]
                            prof = DbProfile(db_sugestions[0])
#                            if db_sugestions[0]:
#                                print 'WARN: using the first of multiple suggestions.'
                            line = re.sub(m_boxname, prof.boxname, line, re.IGNORECASE)
                            match_msgs.append('    * Connection on line {} changing from {} to {}'.
                                              format(linenum, m_boxname, prof.boxname))
                            
                if write: outlines = outlines + line

            # sort by linenum
            match_dict[filename] = sorted(cmiList, key = lambda x: x.linenum)

            if write:
                outfilename = ConfigMgr.get_output_filename(filename)
                with open(outfilename, 'w') as outfile:
                    outfile.write(outlines)
                match_msgs.append('Wrote file ' + outfilename)
        
        match_msgs.append(ConfigMgr.match_dict_summary(match_dict))
        
        if verbose: print os.linesep.join(match_msgs)
        
        return match_dict


if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    doctest.testfile("tests/test_ConfigMgr.txt")
    sys.exit(0)
    #sys.exit(main())



