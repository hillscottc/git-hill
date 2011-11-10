#! /usr/bin/python

import os
import sys
import getopt
import csv

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

class DbProfile(object):
    """
    Represents a database instance by dbname, env, boxname, and path. 

    Usage: 
    Run these tests with ./DbProfile.py -v
    
    Get a default
    >>> db = DbProfile()
    >>> print db
    MP RDxETL uat usfshwssql104 sourcepath targpath

    Pass in the values
    >>> db = DbProfile('MP', 'RDxETL', 'prod', 'usfshwssql077', 'sourcepath', 'targpath' )
    >>> print db
    MP RDxETL prod usfshwssql077 sourcepath targpath
    """

    Keys = ('app', 'dbname', 'env', 'boxname', 'source', 'targ')
    Envs = ('dev', 'uat', 'prod')


    def __init__(self, app='MP', dbname='RDxETL', env='uat', boxname='usfshwssql104',
                 source='sourcepath', targ='targpath', tup=None):
        if tup:
            db_dict = dict(zip(self.Keys, tup))
            self.__init__(**db_dict)
        else:
            self.app = app
            self.dbname = dbname
            if (env) and (env not in self.Envs):
                raise Usage('{} is invalid environment. Must be in {}'.format(self.env, self.Envs))
            self.env = env
            self.boxname = boxname
            self.source = source
            self.targ = targ


    def match_attrib(self, aDict):
        """Does given dict of attib-vals match with self data?
        
        >>> db = DbProfile('MP', 'RDxETL', 'prod', 'usfshwssql077', 'sourcepath', 'targpath')
        
        Is this prod etl?
        >>> print db.match_attrib(dict(env='prod', dbname='RDxETL'))
        True
        
        Is it dev etl?
        >>> print db.match_attrib(dict(env='dev', dbname='RDxETL'))
        False
        
        Is it MP app prod etl on usfshwssql077?
        >>> print db.match_attrib(dict(app='MP', env='prod', dbname='RDxETL', boxname='usfshwssql077'))
        True
        """
        
        for k, v in aDict.iteritems():
            if not (vars(self)[k] == v) :
                return False
        return True
        
    def long_str(self):
        """ Includes the source and targ paths."""
        return str(self.__str__() + ' ' + self.source + ' ' + self.targ)      

    def __str__(self):
        """ Doesn't include source and targ paths."""
        return self.app + ' ' + self.dbname + ' ' + self.env + ' ' + self.boxname

    def __repr__(self):
        return str(self.__str__())

if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)    
    doctest.testfile("tests/test_DbSet.txt")
    sys.exit(0)
    #sys.exit(main())


    