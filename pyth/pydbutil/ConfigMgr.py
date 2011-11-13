#! /usr/bin/python
"""Handles database connection strings in files using DbProfiles.

Usage: 
Init the class with -dbsetfile and -path and call the public functions:
#     check()      - to look for conn strings in any file via regex. No changes.
#     handle_xml() - look for conn strings in config file via xml parse. The Write
#                    option will write new file in output directory.
# 
# >>> cm = ConfigMgr(dbsource='input/DbSet.data.csv', path='input/test.config')
# >>> cm.handle_xml(write=False, env='prod')
# File: /Users/hills/git-hill/pyth/pydbutil/input/test.config
# Conn change: RDxETL connection from Usfshwssql094 to usfshwssql077
# Conn change: RDxETL connection from Usfshwssql094 to usfshwssql077
# Conn change: RDxETL connection from Usfshwssql094 to usfshwssql077
# Conn change: RDxReport connection from Usfshwssql089 to usfshwssql084
# <BLANKLINE>
# 4 matches in file input/test.config
# <BLANKLINE>

The rest of the usage tests are in 'test_ConfigMgr.txt'
To call the tests:,
   ./ConfigMgr.py -v 

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
        self.path = path
        self.env = env
        self.write = write
        self.verbose = verbose
        

    def set_path(self, value):
        if not self.app: raise Exception('app is required when setting path.')
        self.filelist = ConfigMgr.get_filelist(self.app, value)
        self._path = value

    def get_path(self):
        return self._path

    path = property(get_path, set_path)

    @staticmethod
    def get_filelist(app=None, path=None):
        """Gets config files for app name in given path. 
        Matches files with {app}*.exe in the file for the given path.

        Usage:  
        >>> print ConfigMgr.get_filelist('MP', 'input/')
        ['input/UMG.RDx.ETL.MP.exe.config', 'input/UMG.RDx.ETL.MP.vshost.exe.config']
        >>> print ConfigMgr.get_filelist('ABC', 'input/UMG.RDx.ETL.MP.exe.config')
        Traceback (most recent call last):
            ...
        Exception: input/UMG.RDx.ETL.MP.exe.config does not match with app ABC
        """
        if not app: raise Exception('app is required for get_filelist.')
        if not path: raise Exception('path is required for get_filelist.')
        filelist = []
        if os.path.isfile(path) :
            if re.search(app + '.+exe', path): 
                filelist = [path]
            else:
                raise Exception, '{} does not match with app {}'.format(path, app)
        elif os.path.isdir(path) :
            #iterate files in specified dir that match *.config
            for filename in glob.glob(os.path.join(path,  "*.config")) :
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


    def get_conn_matches(self, filelist=None, app=None, env=None, write=False, verbose=False) :
        """Checks file for lines which contain connection string information,
        for each file in filelist.
        Returns:
        Dict of match data and line num, keyed by filename.
        Usage:
        Set path to one file, check.
        >>> cm = ConfigMgr(dbsource='input/DbSet.data.csv', app='MP', path='input/UMG.RDx.ETL.MP.vshost.exe.config')
        >>> match_dict = cm.get_conn_matches()
        >>> print match_dict
        {'input/UMG.RDx.ETL.MP.vshost.exe.config': [Usfshwssql094 RDxETL 69, Usfshwssql094 RDxETL 74, Usfshwssql094 RDxETL 78, Usfshwssql089 RDxReport 82]}
        >>> print ['{} matches in file {}'.format(len(match_dict[filename]), filename) for filename in match_dict.keys()]
        ['4 matches in file input/UMG.RDx.ETL.MP.vshost.exe.config']
        >>> x = cm.get_conn_matches(verbose=True, app='MP', env='uat')
        Checking against dbset for app 'MP', in 'uat' environment.
        In file input/UMG.RDx.ETL.MP.vshost.exe.config:
          Usfshwssql094 RDxETL 69 matched MP RDxETL uat usfshwssql094 from the dbset.
          Usfshwssql094 RDxETL 74 matched MP RDxETL uat usfshwssql094 from the dbset.
          Usfshwssql094 RDxETL 78 matched MP RDxETL uat usfshwssql094 from the dbset.
          Usfshwssql089 RDxReport 82 matched MP RDxReport uat usfshwssql089 from the dbset.
        >>> x = cm.get_conn_matches(verbose=True, app='MP', env='prod')
        Checking against dbset for app 'MP', in 'prod' environment.
        In file input/UMG.RDx.ETL.MP.vshost.exe.config:
          Usfshwssql094 RDxETL 69 matched None from the dbset.
            * dbset profile for MP/prod is MP RDxETL prod usfshwssql077
          Usfshwssql094 RDxETL 74 matched None from the dbset.
            * dbset profile for MP/prod is MP RDxETL prod usfshwssql077
          Usfshwssql094 RDxETL 78 matched None from the dbset.
            * dbset profile for MP/prod is MP RDxETL prod usfshwssql077
          Usfshwssql089 RDxReport 82 matched None from the dbset.
            * dbset profile for MP/prod is MP RDxReport prod usfshwssql084
        >>> x = cm.get_conn_matches(verbose=True, app='MP', env='prod', write=True)
        Checking against dbset for app 'MP', in 'prod' environment.
        In file input/UMG.RDx.ETL.MP.vshost.exe.config:
          Usfshwssql094 RDxETL 69 matched None from the dbset.
            * dbset profile for MP/prod is MP RDxETL prod usfshwssql077
            * Connection on line 69 changing from Usfshwssql094 to usfshwssql077
          Usfshwssql094 RDxETL 74 matched None from the dbset.
            * dbset profile for MP/prod is MP RDxETL prod usfshwssql077
            * Connection on line 74 changing from Usfshwssql094 to usfshwssql077
          Usfshwssql094 RDxETL 78 matched None from the dbset.
            * dbset profile for MP/prod is MP RDxETL prod usfshwssql077
            * Connection on line 78 changing from Usfshwssql094 to usfshwssql077
          Usfshwssql089 RDxReport 82 matched None from the dbset.
            * dbset profile for MP/prod is MP RDxReport prod usfshwssql084
            * Connection on line 82 changing from Usfshwssql089 to usfshwssql084
        Wrote file /Users/hills/git-hill/pyth/pydbutil/output/UMG.RDx.ETL.MP.vshost.exe.config
        
        """
        
        if not filelist:
            filelist = self.filelist
        if not filelist:
            filelist = self.filelist
            raise Exception('filelist required.')
        
        if write:
            if not env:
                env = self.env
            if not env :
                raise Exception('env is required for write.')
        
            if not app :
                raise Exception('app is required for write.')
        
        
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


    def change_conn(self, old_conn, new_env='DEV'):
        """Change db connection strings via re.
        Usage:
        """   
        
        if (not self.dbset) or (len(self.dbset) is 0) :
            raise Exception('Cannot change_con because dbset is empty or invalid.')
             
        new_conn = old_conn # default to orig val if no match

        m = re.search(self.REGEX, old_conn)
        if m:
            boxname, dbname = m.group(1), m.group(2)

            new_boxname = '***BAD BOX NAME***'
            db = self.dbset.get_profile_by_attribs(dict(dbname=dbname,env=new_env))
            if db : 
                new_boxname =  db.boxname
            print 'Conn change: {} connection from {} to {}'.format(
                                             dbname, boxname, new_boxname)
            new_conn = re.sub(boxname, new_boxname, old_conn)

        return new_conn




if __name__ == "__main__":
    import doctest
    #doctest.testfile("tests/test_ConfigMgr.txt")
    doctest.testmod(verbose=True)
    sys.exit(0)
    #sys.exit(main())



