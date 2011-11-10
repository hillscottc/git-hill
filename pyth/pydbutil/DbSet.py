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

