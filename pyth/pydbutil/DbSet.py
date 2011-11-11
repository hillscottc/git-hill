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

class DbSet(object):
    """Manages database profiles. Takes a csv file as input.
    Usage:
    >>> dbset = DbSet('input/DbSet.data.csv')
    >>> print len(dbset)
    12
    """
    DB = []
    def __init__(self, cvsfile=None, dbprofiles=[],
                 regex='Data Source=(Usfshwssql\w+);Initial Catalog=(RDx\w+);'):
        self.DB = []
        self.regex = regex
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

    def get_profile_by_attribs(self, aDict):
        """Does given dict of attrib-vals match with self data?
        
        Usage:
        >>> dbset = DbSet('input/DbSet.data.csv')
        
        Have a training RDxETL?
        #>>> print dbset.get_profile_by_attribs(dict(env='training', dbname='RDxETL'))
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
    doctest.testmod(verbose=True)
    doctest.testfile("tests/test_DbSet.txt")
    sys.exit(0)

