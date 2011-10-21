#! /usr/bin/python
""" Handles database profiles. Primarily used as a library.

Usage: 
    ./DbProfile.py
Args:
    -p: targ file or dir
    -e: the env to switch to {env, uat, or prod}    
    -w: writes output file 
Returns:
Raises:
"""

import sys
import getopt

# The dict of DbProfile objects
DB = {}

ENVS = ['DEV', 'UAT', 'PROD']

# The keys defining a DbProfile values...
_db_data_keys = (
     'dbname', 'env', 'boxname', 'path')

_db_data = (
    ('RDxETL',    'DEV', 'usfshwssql104', r'D:\Something'),
    ('RDxETL',    'UAT', 'usfshwssql094', r'D:\Something'),
    ('RDxETL',    'PROD','usfshwssql077', r'D:\Something'),
    ('RDxReport', 'UAT', 'usfshwssql089', r'D:\Something'),
    ('RDxReport', 'PROD','usfshwssql084', r'D:\Something'),
    ('RDxReport', 'DEV', 'usfshwssql104\RIGHTSDEV_2', r'D:\Something') 
)

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

class DbProfile:
    """ Used to describe a database instance. """
    def __init__(self, dbname, env, boxname, path):
        self.dbname = dbname
        self.env = env
        self.boxname = boxname
        self.path = path
    def __str__(self):
        return self.dbname, self.env, self.boxname, self.path
    def __repr__(self):
        return str(self.__str__())
    def get_key(self):
        # key is a tuple
        return (self.dbname, self.env)

def load_data():
    """ Load the DB dictionary with the raw data."""
    for db_data_rec in _db_data:
        db_dict = dict(zip(_db_data_keys, db_data_rec))
        db = DbProfile(**db_dict)  # **=unpack
        # add as a dict with key=(d.dbname, d.env), val=DbProfile d
        DB[db.get_key()] = db    


def get_profile(dbname, env):
    """ Get matching profile from data."""
    return DB[(dbname, env)]


# Load the data. 
print 'Initializing DbProfiles.'
load_data()


def main(argv=None):
    if argv is None:
         argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(argv[1:], "h", ["help"])
        except getopt.error, msg:
            raise Usage(msg)

        for opt, arg in opts :
            if opt in ("-h", "--help"):
                print __doc__
                sys.exit(0)

        print 'Test profile access...'
        print DB

    except Usage, err:
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:",err.msg
        return 2

if __name__ == "__main__":
    sys.exit(main())

