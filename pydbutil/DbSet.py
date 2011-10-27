#! /usr/bin/python
"""Manages a collection of database profiles.
Takes a csv file as input.

Usage: 
    ./DbSet.py -i DbSet.data.csv
Args:
    -i: infile (csv format)
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
    def __init__(self, dbprofiles=[], cvsfile=None):
        self.DB = {}
        if cvsfile:
            print 'Loading file {}'.format(cvsfile)
            dr = csv.DictReader(open(cvsfile, 'rb'), delimiter=',', quotechar="'")
            self.__init__(dbprofiles=[DbProfile(**row) for row in dr])
        else:
            print 'Loading data {}'.format(dbprofiles)
            for db in dbprofiles:   
                self.DB[db.get_key()] = db
            print 'Loaded {} profiles.'.format(len(self.DB))

    def get_profile(self, dbname, env):
        """ Get matching profile from data."""
        return self.DB[(dbname, env)]

    def __str__(self):
        s = ''
        return str([s + str(dbprofile) for dbprofile in self.DB])  
    def __repr__(self):
        return str(self.__str__())        


def main(argv=None):
    if argv is None:
         argv = sys.argv
    try:

        try:
            opts, args = getopt.getopt(argv[1:], "hi:", ["help", "infile="])
        except getopt.error, msg:
            raise Usage(msg)

        infile = None

        for opt, arg in opts :
            if opt in ("-h", "--help"):
                print __doc__
                sys.exit(0)
            elif opt in ("-i", "--infile"):
                infile = arg

        if not os.path.isfile(infile) :
            raise Usage("Invalid -i '{}'".format(infile))   

        #main_test(infile)
        
        print 'Create DbSet -- {}'.format(DbSet(cvsfile=infile)) 

    except Usage, err:
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:",err.msg
        return 2

if __name__ == "__main__":
    sys.exit(main())

