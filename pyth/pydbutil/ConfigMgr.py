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
#from xml.etree.ElementTree import ElementTree, parse, tostring

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

class ConfigMgr(object):
    """Handles database connection strings in files using DbProfiles.
    
    More usage tests are in 'test_ConfigMgr.txt'
    Run ./ConfigMgr.py -v
    """
    
    REGEX = 'Data Source=(Usfshwssql\w+);Initial Catalog=(RDx\w+);'

    def __init__(self, dbsource=None, path=None, env=None, app=None, write=False, verbose=False):
        self.dbset = DbSet(cvsfile=dbsource)
        self.path = path
        self.env = env
        self.app = app
        self.write = write
        self.verbose = verbose

    def set_path(self, value):
        self.filelist = ConfigMgr.get_filelist(value)
        self._path = value

    def get_path(self):
        return self._path

    path = property(get_path, set_path)

    @staticmethod
    def get_filelist(path):
        """Gets filelist for dir or file path """
        filelist = []
        if path:
            if os.path.isfile(path) :
                filelist = [path]
            elif os.path.isdir(path) :
                #iterate files in specified dir that match *.config
                for config_file in glob.glob(os.path.join(path,  "*.config")) :
                    filelist.append(config_file)
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
    def get_config_files(app='MP', path='input/'):
        """Gets config files for app name in given path. 
        Matches files with {app}*.exe in the file for the given path.

        Usage:  
        >>> print ConfigMgr.get_config_files()
        ['input/UMG.RDx.ETL.MP.exe.config', 'input/UMG.RDx.ETL.MP.vshost.exe.config']
        """
        config_files = []
        for filename in glob.glob(os.path.join(path,  "*.config")) :
            if re.search(app + '.+exe', filename): 
                config_files.append(filename)
        return config_files
            


    def get_conn_matches(self, filelist=None, app=None, env=None, verbose=False):
        """Checks file for lines which contain connection string information,
        for each file in filelist.
        Returns:
        Dict of match data and line num, keyed by filename.
        Usage:
        Set path to one file, check.
        >>> cm = ConfigMgr(dbsource='input/DbSet.data.csv', path='input/UMG.RDx.ETL.R2.vshost.exe.config')
        >>> match_dict = cm.get_conn_matches()
        >>> print match_dict
        {'input/UMG.RDx.ETL.R2.vshost.exe.config': [usfshwssql104 RDxETL 8, usfshwssql104 RDxETL 13, usfshwssql104 RDxETL 17, usfshwssql104 RDxReport 21]}
        >>> print ['{} matches in file {}'.format(len(match_dict[filename]), filename) for filename in match_dict.keys()]
        ['4 matches in file input/UMG.RDx.ETL.R2.vshost.exe.config']
        >>> x = cm.get_conn_matches(verbose=True, app='MP', env='dev')
        Checking against dbset for app 'MP', in 'dev' environment.
        In file input/UMG.RDx.ETL.R2.vshost.exe.config:
          usfshwssql104 RDxETL 8 matched MP RDxETL dev usfshwssql104 from the dbset.
          usfshwssql104 RDxETL 13 matched MP RDxETL dev usfshwssql104 from the dbset.
          usfshwssql104 RDxETL 17 matched MP RDxETL dev usfshwssql104 from the dbset.
          usfshwssql104 RDxReport 21 matched None from the dbset.
            * dbset profile for MP/dev is MP RDxReport dev usfshwssql104\RIGHTSDEV_2
        >>> x = cm.get_conn_matches(verbose=True, app='MP', env='prod')
        Checking against dbset for app 'MP', in 'prod' environment.
        In file input/UMG.RDx.ETL.R2.vshost.exe.config:
          usfshwssql104 RDxETL 8 matched None from the dbset.
            * dbset profile for MP/prod is MP RDxETL prod usfshwssql077
          usfshwssql104 RDxETL 13 matched None from the dbset.
            * dbset profile for MP/prod is MP RDxETL prod usfshwssql077
          usfshwssql104 RDxETL 17 matched None from the dbset.
            * dbset profile for MP/prod is MP RDxETL prod usfshwssql077
          usfshwssql104 RDxReport 21 matched None from the dbset.
            * dbset profile for MP/prod is MP RDxReport prod usfshwssql084
        """
        
        if not filelist:
            filelist = self.filelist
        if not filelist:
            filelist = self.filelist   
            raise Usage('filelist required.')
            
        if verbose:
            if not env:
                env = self.env
            if not env :
                raise Usage('env is required.')

            if not app :
                raise Usage('app is required.')


        tot_match_count = 0
        match_msg = ''
        
        if verbose:
            print "Checking against dbset for app '{}', in '{}' environment.".format(app, env) 
        
        # filename:connInfo[]
        match_dict = {}

        for filename in filelist:
            
            if verbose: print 'In file {}:'.format(filename)

            # read all lines of file into var
            with open(filename, 'r') as file:
                lines = file.readlines()

            connInfo = []
            linenum = 0

            # check lines
            for line in lines:
                linenum = linenum +1
                # regex='Data Source=(Usfshwssql\w+);Initial Catalog=(RDx\w+);'
                # print 'line {}:{}    {}'.format(str(linenum), os.linesep, self.trim_line(line))
                m = re.search(self.REGEX, line, re.IGNORECASE)
                if m:
                    ci = ConnInfo(m.group(1).lower(), m.group(2), linenum)
                    connInfo.append(ci)
                    
                    if verbose:
                        # check against dbset
                        dbset_match = self.dbset.get_profile_by_attribs(
                                dict(boxname=ci.boxname, dbname=ci.dbname, app=app, env=env))                                    
                        print '  {} matched {} from the dbset.'.format(ci, dbset_match)
                        if not dbset_match:
                            print '    * dbset profile for {}/{} is {}'.format(app, env,
                                   self.dbset.get_profile_by_attribs(dict(dbname=ci.dbname, app=app, env=env)))                    


            match_dict[filename] = connInfo

        return match_dict


    def change_conn(self, old_conn, new_env='DEV'):
        """Change db connection strings via re.
        Usage:
        """   
        
        if (not self.dbset) or (len(self.dbset) is 0) :
            raise Usage('Cannot change_con because dbset is empty or invalid.')
             
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


    def get_output_filename(self, filename, outdir="output"):
        """ Returns abs path to ./outdir/filename """
        path = os.path.abspath(filename)
        head, tail = os.path.split(path)
        return os.path.join(os.getcwd(), outdir, tail)






if __name__ == "__main__":
    import doctest
    #doctest.testfile("tests/test_ConfigMgr.txt")
    doctest.testmod(verbose=True)
    sys.exit(0)
    #sys.exit(main())



