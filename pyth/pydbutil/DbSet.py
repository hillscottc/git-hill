#! /usr/bin/python

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
    Loading file input/DbSet.data.csv
    Loaded DbSet with 6 profiles.
    >>> print dbset
    ["('RDxETL', 'uat')", "('RDxETL', 'prod')", "('RDxETL', 'dev')", "('RDxReport', 'uat')", "('RDxReport', 'prod')", "('RDxReport', 'dev')"]
    """    
    DB = {}
    def __init__(self, cvsfile=None, dbprofiles=[],
                 regex='Data Source=(Usfshwssql\w+);Initial Catalog=(RDx\w+);'):
        self.DB = {}
        self.regex = regex
        if cvsfile:
            print 'Loading file {}'.format(cvsfile)
            dr = csv.DictReader(open(cvsfile, 'rb'), delimiter=',', quotechar="'")
            self.__init__(dbprofiles=[DbProfile(**row) for row in dr])
        else:
            #print 'Loading data {}'.format(dbprofiles)
            for db in dbprofiles:   
                self.DB[db.get_key()] = db
            print 'Loaded DbSet with {} profiles.'.format(len(self.DB))

    def get_profile(self, dbname, env):
        """ Get matching profile from data."""
        return self.DB[(dbname, env.lower())]

    def has_db_box(self, dbname, boxname):
        for db in self.DB.itervalues():
            if db.matches_db_box(dbname, boxname):
                #print 'match with {}'.format(db)
                return True
        return False


    def __str__(self):
        return str([str(dbprofile) for dbprofile in self.DB])  
    def __repr__(self):
        return str(self.__str__())


if __name__ == "__main__":
    import doctest
    doctest.testmod()
    #sys.exit(main())

