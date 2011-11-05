#! /usr/bin/python
"""Manages database profiles. Takes a csv file as input.

Usage:
Run tests with ./DbSet.py -v
"""
import os
import sys
import getopt
import csv
from DbProfile import DbProfile

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

class DbSet():
    """Manages database profiles. Takes a csv file as input.
    
    >>> dbset = DbSet('input/DbSet.data.csv')
    
    >>> print sorted(dbset.DB)
    [RDxETL dev usfshwssql104 somepath, RDxETL uat usfshwssql094 somepath, RDxETL prod usfshwssql077 somepath, RDxReport uat usfshwssql089 somepath, RDxReport prod usfshwssql084 somepath, RDxReport dev usfshwssql104\RIGHTSDEV_2 somepath]
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
            #for db in dbprofiles:   
            #    self.DB[db.get_key()] = db             
            self.DB = [db for db in dbprofiles]
            #print 'Loaded {} profile(s).'.format(len(self.DB))

    def __len__(self):
        return len(self.DB)

    def get_profile_by_attribs(self, aDict):
        """Does given dict of attib-vals match with self data?
        
        >>> dbset = DbSet('input/DbSet.data.csv')
        
        Have a training RDxETL?
        >>> print dbset.get_profile_by_attribs(dict(env='training', dbname='RDxETL'))
        None
        
        Have a prod RDxETL?
        >>> print dbset.get_profile_by_attribs(dict(env='prod', dbname='RDxETL'))
        RDxETL prod usfshwssql077 somepath
        
        Have a prod box on usfshwssql084?
        >>> print dbset.get_profile_by_attribs(dict(env='prod', boxname='usfshwssql084'))
        RDxReport prod usfshwssql084 somepath
        
        Have a RDxETL on usfshwssql104?
        >>> print dbset.get_profile_by_attribs(dict(dbname='RDxETL', boxname='usfshwssql104'))
        RDxETL dev usfshwssql104 somepath
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
    doctest.testmod()
    #sys.exit(main())

