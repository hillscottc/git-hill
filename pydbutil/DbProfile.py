#! /usr/bin/python
import sys

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

# Load the data. 
print 'Initializing', __name__
load_data()


def main(argv=None):
    print 'Test profile access...'
    print DB


if __name__ == "__main__":
    sys.exit(main())


#for db_data_rec in _db_data:
#    db_dict = dict(zip(_db_data_keys, db_data_rec))
#    db = DbProfile(**db_dict)  # **=unpack
#    #add as a dict, keyed by tuple of (dbname, env)
#    DB[db.get_key()] = db


