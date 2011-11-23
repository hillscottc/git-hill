#! /usr/bin/python
"""Handles database connection strings in files using DbProfiles.

Usage: go() is the main function. Many examples in tests below.
>>> cm = ConfigMgr(dbsource='input/DbSet.data.csv', path='input/ETL/MP/UMG.RDx.ETL.MP.vshost.exe.config')

#>>> match_dict = cm.go()
#>>> print match_dict
#{'input/ETL/MP/UMG.RDx.ETL.MP.vshost.exe.config': [Usfshwssql094 RDxETL 69, Usfshwssql094 RDxETL 74, Usfshwssql094 RDxETL 78, Usfshwssql089 RDxReport 82]}

Call tests with ./ConfigMgr.py -v
"""
import sys
import getopt
import shutil
import re
import os
import glob
from DbProfile import DbProfile
from DbSet import DbSet
from ConnInfo import ConnInfo





# REMOVE app. use whats in the dbset. change it there, if options wanted.




class ConfigMgr(object):
    """Handles database connection strings in files using DbProfiles.
    
    >>> cm = ConfigMgr(dbsource='input/DbSet.data.csv', path='input/ETL/R2/UMG.RDx.ETL.R2.vshost.exe.config')
    
    #>>> cm = ConfigMgr(dbsource='input/DbSet.data.csv', path='input/ETL/R2/UMG.RDx.ETL.R2.vshost.exe.config')
    #Traceback (most recent call last):
    #    ...
    #Exception: input/UMG.RDx.ETL.R2.vshost.exe.config does not match with app MP
    
    More usage tests are in 'test_ConfigMgr.txt'
    Run ./ConfigMgr.py -v
    """
    
    REGEX = 'Data Source=(Usfshwssql\w+);Initial Catalog=(RDx\w+);'

    def __init__(self, dbsource=None, path=None, env=None, write=False, verbose=False):
        #self.dbset = DbSet(cvsfile=dbsource)
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
#                print "RDF " + root, dirs, files
                if skipdir in dirs:
                    dirs.remove(skipdir)
                for name in files:
                    filepathname = os.path.join(root, name)
                    
                    froot, ext = os.path.splitext(filepathname)
                    
                    print filepathname, ext, '.config'
                    
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
    def get_output_filename(filename, outdir="output"):
        """ Returns abs path to ./outdir/filename """
        path = os.path.abspath(filename)
        head, tail = os.path.split(path)
        return os.path.join(os.getcwd(), outdir, tail)        


    def go(self, filelist=None, app=None, env=None, write=False, verbose=False) :
        """Checks file for lines which contain connection string information,
        for each file in filelist.
                
        If not app, then use whats in the fileset.
        
        Returns:
            Dict of match data and line num, keyed by filename.
        
        Usage:
        
        >>> cm = ConfigMgr(dbsource='input/DbSet.data.csv', path='input/ETL/MP/UMG.RDx.ETL.MP.vshost.exe.config')
        >>> match_dict = cm.go()
        >>> print match_dict
        {'input/ETL/MP/UMG.RDx.ETL.MP.vshost.exe.config': [Usfshwssql094 RDxETL 69, Usfshwssql094 RDxETL 74, Usfshwssql094 RDxETL 78, Usfshwssql089 RDxReport 82]}
        
        >>> print ['{} matches in file {}'.format(len(match_dict[filename]), filename) for filename in match_dict.keys()]
        ['4 matches in file input/ETL/MP/UMG.RDx.ETL.MP.vshost.exe.config']
        
        >>> print cm.filelist
        ['input/ETL/MP/UMG.RDx.ETL.MP.vshost.exe.config']
        
        >>> cm.path = 'input/ETL/'
        >>> print 'Count:' ,  len(cm.filelist)
        Count: 22
        
        >>> cm.path = 'input/ETL/CPRS/'
        >>> print cm.filelist
        >>> print 'Count:' ,  len(cm.filelist)
        Count: 2
        
        
        
        #>>> match_dict = cm.go()
        #>>> print match_dict
        
                
        #>>> match_dict = cm.go(app='MP')
        #>>> print match_dict 

        INCLUDE THE CARL in the tests, cuz it has funky dbs

        
        """
        
        if not filelist:
            filelist = self.filelist
        if not filelist:
            raise Exception('filelist required.')
        
        if write or verbose:
            if not env:
                env = self.env
            if not env :
                raise Exception('env is required for write or verbose.')
        
        if verbose:
            if app: appMsg = app
            else: appMsg = "DbSet filelist."
            
            print "Checking filelist for env: {}, apps: {} ".format(env, appMsg)        

        match_dict = {}
        
        
        for filename in filelist:
            
            # if we wanted specific app files from filelist...
            if app:
                if not re.search(app, filename):
                    continue;

            if write :
                outfilename = self.get_output_filename(filename)
            
            if verbose:
                print 'In file {}:'.format(filename)

            # read all lines of file into var
            with open(filename, 'r') as file:
                lines = file.readlines()

            connInfo = []
            linenum = 0
            outlines = ''

            # check lines
            for line in lines:
                linenum = linenum +1
                # print 'line {}:{}    {}'.format(str(linenum), os.linesep, self.trim_line(line))
                m = re.search(self.REGEX, line, re.IGNORECASE)
                if m:
                    m_boxname, m_dbname = m.group(1), m.group(2)
                    ci = ConnInfo(m_boxname, m_dbname, linenum)
                    connInfo.append(ci)

                    # check against dbset
                    #prof = dict(boxname=ci.boxname.lower(), dbname=ci.dbname, app=app, env=env)
                    
                    profDict = dict(boxname=ci.boxname.lower(), dbname=ci.dbname, env=env)
                    if app:
                        profDict['app'] = app
                    
                    dbset_match = self.dbset.get_profiles_by_attribs(profDict)

                    if verbose:
                        print '  {} matched {} from the dbset.'.format(ci, dbset_match)

                    if not dbset_match:
                        db_suggest = self.dbset.get_profiles_by_attribs(dict(dbname=ci.dbname, app=app, env=env))
                        if verbose:
                            print '    * dbset profile for {}/{} is {}'.format(app, env, db_suggest)
                        if write:
                            if verbose:
                                print '    * Connection on line {} changing from {} to {}'.format(
                                       linenum, m_boxname, db_suggest.boxname)
                            line = re.sub(m_boxname, db_suggest.boxname, line, re.IGNORECASE)
                if write:
                    outlines = outlines + line

            match_dict[filename] = connInfo

            if write:
                outfilename = ConfigMgr.get_output_filename(filename)
                with open(outfilename, 'r+') as outfile:
                    outfile.write(outlines)
                print 'Wrote file ' + outfilename

        return match_dict


if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    #doctest.testfile("tests/test_ConfigMgr.txt")
    sys.exit(0)
    #sys.exit(main())



