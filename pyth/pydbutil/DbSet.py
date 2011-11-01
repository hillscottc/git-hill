#! /usr/bin/python
"""
Manages database profiles.
Can takes a csv file as input.

Usage: 
#    ./DbSet.py -i input/DbSet.data.csv

 
>>> db = DbSet(input/DbSet.data.csv)
>>> print dbset

    
Args:
Returns:
Raises:
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


# def main(argv=None):
#     if argv is None:
#          argv = sys.argv
#     try:
#         try:
#             opts, args = getopt.getopt(argv[1:], "hi:", ["help", "infile="])
#         except getopt.error, msg:
#             raise Usage(msg)
# 
#         infile = None
#         
#         for opt, arg in opts :
#             if opt in ("-h", "--help"):
#                 print __doc__
#                 sys.exit(0)
#             elif opt in ("-i", "--infile"):
#                 infile = arg
#                 if not os.path.isfile(infile) :
#                     raise Usage("Invalid -i '{}'".format(infile))
#                 else:
#                     print 'Creating DbSet from infile -- {}'.format(DbSet(cvsfile=infile))
# 
#     except Usage, err:
#         print >>sys.stderr, "Sorry, invalid options. For help, use --help"
#         print >>sys.stderr, "Other errors:",err.msg
#         return 2

