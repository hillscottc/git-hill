#! /usr/bin/python
"""Handles database connection strings in files using DbProfiles.

Usage: go() is the main function. Many examples in tests below.
>>> cm = ConfigMgr(dbsource='input/DbSet.data.csv', app='MP', path='input/UMG.RDx.ETL.MP.vshost.exe.config')
>>> match_dict = cm.go()
>>> print match_dict
{'input/UMG.RDx.ETL.MP.vshost.exe.config': [Usfshwssql094 RDxETL 69, Usfshwssql094 RDxETL 74, Usfshwssql094 RDxETL 78, Usfshwssql089 RDxReport 82]}

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


class ConfigMgr(object):
    """Handles database connection strings in files using DbProfiles.
    
    >>> cm = ConfigMgr(dbsource='input/DbSet.data.csv', app='R2', path='input/UMG.RDx.ETL.R2.vshost.exe.config')
    
    >>> cm = ConfigMgr(dbsource='input/DbSet.data.csv', app='MP', path='input/UMG.RDx.ETL.R2.vshost.exe.config')
    Traceback (most recent call last):
        ...
    Exception: input/UMG.RDx.ETL.R2.vshost.exe.config does not match with app MP
    
    More usage tests are in 'test_ConfigMgr.txt'
    Run ./ConfigMgr.py -v
    """
    
    REGEX = 'Data Source=(Usfshwssql\w+);Initial Catalog=(RDx\w+);'

    def __init__(self, dbsource=None, app=None, path=None, env=None, write=False, verbose=False):
        self.dbset = DbSet(cvsfile=dbsource)
        self.app = app
        if path: self.path = path
        self.env = env
        self.write = write
        self.verbose = verbose
        

    def set_path(self, value):
        if not self.app: raise Exception('app is required when setting path.')
        self.filelist = ConfigMgr.get_filelist(value, self.app)
        self._path = value

    def get_path(self):
        return self._path

    path = property(get_path, set_path)

    @staticmethod
    def get_filelist(path=None, *apps):
        """Gets config files for app name in given path. 
        Matches files with {app}*.exe in the file for the given path.

        Usage:  
        >>> print ConfigMgr.get_filelist('input/', 'MP')
        ['input/UMG.RDx.ETL.MP.exe.config', 'input/UMG.RDx.ETL.MP.vshost.exe.config']
        >>> print ConfigMgr.get_filelist('input/UMG.RDx.ETL.MP.exe.config','ABC')
        Traceback (most recent call last):
            ...
        Exception: input/UMG.RDx.ETL.MP.exe.config does not match with app ABC
        >>> print ConfigMgr.get_filelist('input/', 'MP', 'R2')
        ['input/UMG.RDx.ETL.MP.exe.config', 'input/UMG.RDx.ETL.MP.vshost.exe.config', 'input/UMG.RDx.ETL.R2.exe.config', 'input/UMG.RDx.ETL.R2.vshost.exe.config']
        """
        if not apps: raise Exception('apps required for get_filelist.')
        if not path: raise Exception('path is required for get_filelist.')
        filelist = []
        
        for app in apps:
        
            if os.path.isfile(path) :
                if re.search(app + '.+exe', path): 
                    filelist = [path]
                else:
                    raise Exception, '{} does not match with app {}'.format(path, app)
            elif os.path.isdir(path) :
                #iterate files in specified dir that match *.config
#                for filename in glob.glob(os.path.join(path,  "*.config")) :
#                    if re.search(app + '.+exe', filename): 
#                        filelist.append(filename)
                        
                for root, dirs, files in os.walk(path):
                    for name in dirs:
                        #os.xxx(os.path.join(root, name))   
                        #print ' HEY!!!' +  os.path.join(root, name, "*.config")
                        for filename in glob.glob(os.path.join(root, name, "*.config")) :
                            if re.search(app + '.+exe', filename): 
                                filelist.append(filename)                                      
        
        
                        
        #print 'Got filelist {}'.format(filelist)
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
        Returns:
            Dict of match data and line num, keyed by filename.
        Usage:
        >>> cm = ConfigMgr(dbsource='input/DbSet.data.csv', app='MP', path='input/UMG.RDx.ETL.MP.vshost.exe.config')
        >>> match_dict = cm.go()
        >>> print match_dict
        {'input/UMG.RDx.ETL.MP.vshost.exe.config': [Usfshwssql094 RDxETL 69, Usfshwssql094 RDxETL 74, Usfshwssql094 RDxETL 78, Usfshwssql089 RDxReport 82]}
        >>> print ['{} matches in file {}'.format(len(match_dict[filename]), filename) for filename in match_dict.keys()]
        ['4 matches in file input/UMG.RDx.ETL.MP.vshost.exe.config']
        """
        
        if not filelist:
            filelist = self.filelist
        if not filelist:
            filelist = self.filelist
            raise Exception('filelist required.')
        
        if write or verbose:
            if not env:
                env = self.env
            if not env :
                raise Exception('env is required for write or verbose.')
        
            if not app :
                app = self.app
            if not app :
                raise Exception('app is required for write or verbose.')
        
        
        tot_match_count = 0
        match_msg = ''
        
        if verbose:
            print "Checking against dbset for app '{}', in '{}' environment.".format(app, env)
        
        # filename:connInfo[]
        match_dict = {}
        
        for filename in filelist:

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
                    prof = dict(boxname=ci.boxname.lower(), dbname=ci.dbname, app=app, env=env)
                    dbset_match = self.dbset.get_profile_by_attribs(prof)

                    if verbose:
                        print '  {} matched {} from the dbset.'.format(ci, dbset_match)

                    if not dbset_match:
                        db_suggest = self.dbset.get_profile_by_attribs(dict(dbname=ci.dbname, app=app, env=env))
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
                with open(outfilename, 'r+') as file:
                    file.write(outlines)
                print 'Wrote file ' + outfilename

        return match_dict


if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    doctest.testfile("tests/test_ConfigMgr.txt")
    sys.exit(0)
    #sys.exit(main())



