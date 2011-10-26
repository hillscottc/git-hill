#! /usr/bin/python
""" Handles a collection of database profiles.

Usage: 
    ./DbSet.py -i DbSet.data.csv
Args:
    -i: in source data
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
    """ Handles a collection of database profiles."""
    
    DB = {}
    
    def __init__(self, dbprofiles):
        print 'Loading given dbprofiles...'
        self.DB = {}
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


def main_test(infile):
    """ Demo run."""
    
    # read all lines of file into var    
    #with open(infile, 'r') as file:
    #    lines = file.readlines()

    dbprofiles = []    

    dr = csv.DictReader(open(infile, 'rb'), delimiter=',', quotechar="'")            
    for row in dr:
        p = DbProfile(**row)
        print 'Read:', p
        dbprofiles.append(p)

    dbset = DbSet(dbprofiles)

    print 'dbset created.', dbset
    print dbset.DB


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

        main_test(infile)
             
    except Usage, err:
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:",err.msg
        return 2

if __name__ == "__main__":
    sys.exit(main())

