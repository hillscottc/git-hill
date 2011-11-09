#! /usr/bin/python
"""Manages database profiles. Takes a csv file as input.

Usage:
Run tests with ./DbSet.py -v
"""
import re
import os
import glob
import sys
import getopt
import csv
from DbProfile import DbProfile

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

class DbSet():
    """Manages database profiles. Takes a csv file as input.
    
    Usage:
    >>> dbset = DbSet('input/DbSet.data.csv')
    
    """
    DB = []
    def __init__(self, cvsfile=None, dbprofiles=[],
                 regex='Data Source=(Usfshwssql\w+);Initial Catalog=(RDx\w+);'):
        self.DB = []
        self.regex = regex
        if cvsfile:
            dr = csv.DictReader(open(cvsfile, 'rb'), delimiter=',', quotechar="'")
            self.__init__(dbprofiles=[DbProfile(**row) for row in dr])
        else:
            self.DB = [db for db in dbprofiles]
            #print 'Loaded {} profile(s).'.format(len(self.DB))

    def __len__(self):
        return len(self.DB)
    
    def get_config_files(self, app, path):
        """Gets config files for app name in given path
        
        Usage:
        >>> dbset = DbSet('input/DbSet.data.csv')
        >>> dbp = dbset.get_profile_by_attribs(dict(dbname='RDxETL', boxname='usfshwssql104'))     
        >>> files = dbset.get_config_files(dbp.app, dbp.targ)
        >>> print files
        ['/Users/hills/git-hill/pyth/pydbutil/input/UMG.RDx.ETL.MP.exe.config', '/Users/hills/git-hill/pyth/pydbutil/input/UMG.RDx.ETL.MP.vshost.exe.config']
        """
        config_files = []
        for filename in glob.glob(os.path.join(path,  "*.config")) :
            if re.search(app + '.+exe', filename): 
                config_files.append(filename)
        return config_files
    
    def verify_targets(self):
        """Does the db env of the targs match the env it should be?
        Used to do a before-after check for updates, for example.
        
        Usage:
        >>> dbset = DbSet('input/DbSet.data.csv')   
        >>> dbset.verify_targets()
        
        
        NOT WORKING YET.
        
         
        """
        #bad = [dbp for dbp in self.DB if (dbp.targ) and not os.path.isfile(dbp.targ) ]
        for dbp in self.DB:
            if (dbp.targ):
                config_files = self.get_config_files(dbp.app, dbp.targ)
                bad = [f for f in config_files if not os.path.isfile(f)]
                print 'Bad files: {}'.format(bad)


    def get_profile_by_attribs(self, aDict):
        """Does given dict of attib-vals match with self data?
        
        Usage:
        >>> dbset = DbSet('input/DbSet.data.csv')
        
        Have a training RDxETL?
        >>> print dbset.get_profile_by_attribs(dict(env='training', dbname='RDxETL'))
        None
        
        """
        for db in self.DB:
            if db.match_attrib(aDict):
                return db         
        return None

    def __str__(self):
        return str([str(dbprofile) for dbprofile in self.DB])  
    def __repr__(self):
        return str(self.__str__())


if __name__ == "__main__":
    import doctest
    doctest.testfile("tests/test_DbSet.txt")
    doctest.testmod(verbose=True)    
    sys.exit(0)

