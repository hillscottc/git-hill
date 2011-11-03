#! /usr/bin/python

import os
import sys
import getopt
import csv

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

class DbProfile():
    """
    Represents a database instance by dbname, env, boxname, and path. 

    Usage: 
    Run these tests with ./DbProfile.py -v
    
    Get a default
    >>> db = DbProfile()
    >>> print db
    RDxETL uat usfshwssql104 somepath

    Pass in the values
    >>> db = DbProfile('RDxETL', 'prod', 'usfshwssql077', 'prodpath' )
    >>> print db
    RDxETL prod usfshwssql077 prodpath
    """

    Keys = ('dbname', 'env', 'boxname', 'path')
    Envs = ('dev', 'uat', 'prod')

    def __init__(self, dbname='RDxETL', env='uat', boxname='usfshwssql104',
                 path='somepath', tup=None):
        if tup:
            db_dict = dict(zip(self.Keys, tup))
            self.__init__(**db_dict)
        else:
            self.dbname = dbname
            if (env) and (env not in self.Envs):
                raise Usage('{} is invalid environment. Must be in {}'.format(self.env, self.Envs))
            self.env = env
            self.boxname = boxname
            self.path = path

    def match_attrib(self, aDict):
        """Does given dict of attib-vals match with self data?
        
        >>> db = DbProfile('RDxETL', 'prod', 'usfshwssql077', 'prodpath' )
        
        Is this prod etl?
        >>> print db.match_attrib(dict(env='prod', dbname='RDxETL'))
        True
        
        Is it dev etl?
        >>> print db.match_attrib(dict(env='dev', dbname='RDxETL'))
        False
        
        Is it prod etl on usfshwssql077?
        >>> print db.match_attrib(dict(env='prod', dbname='RDxETL', boxname='usfshwssql077'))
        True
        """
        
        for k, v in aDict.iteritems():
            if not (vars(self)[k] == v) :
                return False
        return True

    def __str__(self):
        return self.dbname + ' ' + self.env + ' ' + self.boxname + ' ' + self.path

    def __repr__(self):
        return str(self.__str__())

if __name__ == "__main__":
    import doctest
    doctest.testmod()
    #sys.exit(main())
    
    
    