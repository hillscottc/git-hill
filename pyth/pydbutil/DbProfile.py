#! /usr/bin/python
"""
Manages database profiles.
Can takes a csv file as input.

Usage: 
    ./DbProfile.py -i DbSet.data.csv
    ./DbProfile.py -d "RDxETL PROD usfshwssql077 D:\Something"
Args:
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
    Envs = ('DEV', 'UAT', 'PROD')

    def __init__(self, dbname='RDxETL', env='UAT', boxname='usfshwssql104',
                 path='somepath', tup=None):
        if tup:
            db_dict = dict(zip(self.Keys, tup))
            self.__init__(**db_dict)
        else:
            self.dbname = dbname
            self.env = env.upper() if env else None
            if self.env:
                if self.env not in self.Envs:
                    raise Usage('{} is invalid environment. Must be in {}'.format(self.env, self.Envs))
            self.boxname = boxname
            self.path = path            
    
    def __str__(self):
        return self.dbname + ' ' + self.env + ' ' + self.boxname + ' ' + self.path
    def __repr__(self):
        return str(self.__str__())
    def get_key(self):
        # key is a tuple
        return (self.dbname, self.env)


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
        return str([str(dbprofile) for dbprofile in self.DB])  
    def __repr__(self):
        return str(self.__str__())


def main(argv=None):
    if argv is None:
         argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(argv[1:], "hi:d:", ["help", "infile=","data="])
        except getopt.error, msg:
            raise Usage(msg)

        infile = None
        data = None

        for opt, arg in opts :
            if opt in ("-h", "--help"):
                print __doc__
                sys.exit(0)
            elif opt in ("-i", "--infile"):
                infile = arg
                if not os.path.isfile(infile) :
                    raise Usage("Invalid -i '{}'".format(infile))
                else:
                    print 'Creating DbSet from infile -- {}'.format(DbSet(cvsfile=infile))
            elif opt in ("-d", "--data"):
                data = tuple(arg.split())
                print 'Creating dbprofile from d -- {}'.format(DbProfile(tup=data))      

        print 'Creating a default dbprofile -- ', DbProfile()

    except Usage, err:
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:",err.msg
        return 2

if __name__ == "__main__":
    sys.exit(main())