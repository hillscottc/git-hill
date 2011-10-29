#! /usr/bin/python
"""
Manages database profiles.
Can takes a csv file as input.

Usage: 
    ./DbProfile.py -i DbSet.data.csv
Args:
    -i: infile (csv format)
Returns:
Raises:
"""
import os
import sys
import getopt
import csv

ENVS = ['DEV', 'UAT', 'PROD']

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg


class DbProfile():
    """ Used to describe a database instance. """

    Keys = ('dbname', 'env', 'boxname', 'path')

    def __init__(self, dbname='RDxETL', env='UAT', boxname='usfshwssql104',
                 path='somepath'):
        self.dbname = dbname
        self.env = env
        self.boxname = boxname
        self.path = path

    def __str__(self):
        return self.dbname + ' ' + self.env + ' ' + self.boxname + ' ' + self.path
    def __repr__(self):
        return str(self.__str__())
    def get_key(self):
        # key is a tuple
        return (self.dbname, self.env)


def get_profile_from_tuple(tup):
    """ Create a profile from tuple of values."""
    db_dict = dict(zip(DbProfile.Keys, tup))
    return DbProfile(**db_dict)


class DbSet():
    DB = {}
    def __init__(self, cvsfile=None, dbprofiles=[]):
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
        #s = ''
        return str([str(dbprofile) for dbprofile in self.DB])  
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

        print 'Create dbprofile from default -- ', DbProfile()

        print 'Create dbprofile from tuple -- {}'.format(
            get_profile_from_tuple(('RDxETL', 'PROD', 'usfshwssql077', r'D:\Something')))

        if infile:
            if not os.path.isfile(infile) :
                raise Usage("Invalid -i '{}'".format(infile))
            else:
                print 'Create DbSet -- {}'.format(DbSet(cvsfile=infile))
        
        
    except Usage, err:
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:",err.msg
        return 2

if __name__ == "__main__":
    sys.exit(main())