#! /usr/bin/python

ENVS = ['DEV', 'UAT', 'PROD']

# the keys defining a 'DatabaseProfile', used with following value lists.
_db_data_keys = (
     'dbname', 'env', 'boxname', 'path')

_db_data = (
    ('RDxETL',    'DEV', 'usfshwssql104', r'D:\Something'),
    ('RDxETL',    'UAT', 'usfshwssql094', r'D:\Something'),
    ('RDxETL',    'PROD','usfshwssql077', r'D:\Something'),
    ('RDxReport', 'DEV', 'usfshwssql104\RIGHTSDEV_2', r'D:\Something'),
    ('RDxReport', 'UAT', 'usfshwssql089', r'D:\Something'),
    ('RDxReport', 'PROD','usfshwssql084', r'D:\Something')
)

# The goal is to get a dict of dicts. 
# subdict = {x=1,y=2,z=3}
# Append it to the maindict as below with some key.
#   maindict[a_subdict_key] = subdict
# Easily retrievable same way.
# The db data record is unique by tuple(dbname,env) so i can key them like that.

DB_PROFILES = {} 

#add each as a dict elem, keyed by a tuple of (dbname, env) 
for db_data_rec in _db_data:
    # make dict out of the data row
    db_dict = dict(zip(_db_data_keys, db_data_rec))
    # add new dict as a dict keyed by tuple
    DB_PROFILES[(db_dict['dbname'], db_dict['env'])] = db_dict

# so, a tuple is used as key to get a record.
#rdx_prod_dict = db_profile_dict[('RDxReport','PROD')]
#print 'get rdx prod record (a dict)', rdx_prod_dict





