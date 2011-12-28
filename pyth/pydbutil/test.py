#! /usr/bin/python

import re
import os
from DbProfile import DbProfile
from MatchSet import MatchSet
from collections import namedtuple
from DbSet import DbSet



#def get_profiles(apps=None, dbs=None, envs=None, boxes=None):

envs = ('dev', 'uat')
apps= ('CARL', 'MP', 'R2')
# the lookup dbset of profiles used to specify connections 
Db = namedtuple('Db', 'dbname boxname')
_Dbs = (Db('RDxETL', 'USHPEPVSQL409'), Db('RDxReport', 'USHPEPVSQL409'))   

profs = []
if apps:
    for app in apps:
        for db in _Dbs:
            for env in envs:
                profs.append(DbProfile(app=app, dbname=db.dbname, boxname=db.boxname, env=env))

#print os.linesep.join([str(prof) for prof in profs])

dbset = DbSet(profs)

print os.linesep.join([str(prof) for prof in dbset.DB])

print dbset.get_apps()


