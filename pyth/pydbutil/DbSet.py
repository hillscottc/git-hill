#! /usr/bin/python
"""Manages database profiles. Takes a csv file as input.

Usage:
Run tests with ./DbSet.py -v
"""
import sys
import csv
from DbProfile import DbProfile

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

class DbSet(object):
    """Manages database profiles. Takes a csv file as input.
    Usage:
    >>> dbset = DbSet('input/DbSet.data.csv')
    >>> print len(dbset)
    14
    """
    
    #APPS = ('CARL', 'CART', 'CPRS', 'CRA', 'CTX', 'D2', 'DRA', 'ELS', 'GDRS', 'MP', 'PartsOrder', 'R2')
    
    # these are on 104
    APPS = ('CARL', 'Common', 'CPRS', 'CTX', 'D2', 'DRA', 'GDRS', 'MP', 'PartsOrder', 'R2')
    
    DB = []
    
    def __init__(self, cvsfile=None, dbprofiles=[]):
        self.DB = []
        self.cvsfile = cvsfile
        
    def set_cvsfile(self, value):
        dr = csv.DictReader(open(value, 'rb'), delimiter=',', quotechar="'")
        dbprofiles = [DbProfile(**row) for row in dr]    
        self.DB = [db for db in dbprofiles]
        self._cvsfile = value
        
    def get_cvsfile(self):
        return self._cvsfile

    cvsfile = property(get_cvsfile, set_cvsfile)

    def __len__(self):
        return len(self.DB)

    def get_by_atts(self, aDict):
        """Does given dict of attrib-vals match with self data?
        
        Usage:
        >>> dbset = DbSet('input/DbSet.data.csv')
        
        Have a training RDxETL?
        >>> print dbset.get_by_atts(dict(env='training', dbname='RDxETL'))
        []
        
        What are the MP dev boxes?
        >>> print dbset.get_by_atts(dict(app='MP', env='dev'))
        [MP RDxETL dev usfshwssql104, MP RDxReport dev usfshwssql104\RIGHTSDEV_2]
        
        What are the CARL boxes? (shows example of localhost or (loca) setting for db)
        >>> print dbset.get_by_atts(dict(app='CARL'))        
        [CARL RDxETL dev (local), CARL RDxReport dev localhost]
        """
        profiles = []
        for db in self.DB:
            if db.match_attrib(aDict):
                profiles.append(db)
                #return db
        return profiles

    def __str__(self):
        return str([str(dbprofile) for dbprofile in self.DB])  
    def __repr__(self):
        return str(self.__str__())


if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    doctest.testfile("tests/test_DbSet.txt", verbose=True)
    sys.exit(0)

