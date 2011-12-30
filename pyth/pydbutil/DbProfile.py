#! /usr/bin/python

import sys

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

class DbProfile(object):
    """Represents a database instance by dbname, env, boxname, and path. 
    Usage: 
    Pass in the values
    >>> db = DbProfile('MP', 'RDxETL', 'prod', 'usfshwssql077' )
    >>> print db
    MP RDxETL prod usfshwssql077
    """

    Keys = ('app', 'dbname', 'env', 'boxname')
    Envs = ('dev', 'uat', 'prod')


    def __init__(self, app='MP', dbname='RDxETL', env='uat', boxname='usfshwssql104', tup=None):
        if tup:
            db_dict = dict(zip(self.Keys, tup))
            self.__init__(**db_dict)
        else:
            self.app = app
            self.dbname = dbname
#            if (env) and (env not in self.Envs):
#                raise Usage('{} is invalid environment. Must be in {}'.format(self.env, self.Envs))
            self.env = env
            self.boxname = boxname
 
    
# 
#    def set_boxname(self, value):
#        print 'prop'
#        self._boxname = value.upper()
#
#    def get_boxname(self):
#        print 'prop'
#        return self._boxname.upper()
#
#    boxname = property(get_boxname, set_boxname) 
            

    @staticmethod
    def get_profiles(apps=None, dbs=None, envs=None, boxes=None):
        """Returns a list of profiles for criteria.
        Usage:
        >>> envs = ('dev')
        >>> apps= ('CARL', 'MP')
        >>> profs = DbProfile.get_profiles( envs=envs, apps=apps)
        >>> print [prof for prof in profs]
        """    
        profs = []
        if apps:
            for app in apps:
                for db in dbs:
                    for env in envs:
                        profs.append(DbProfile(app, db.dbname, env, db.boxname))
                                  
        return profs    
                        

    def __eq__(self, other):
        """
        Usage: 
        Pass in the values
        >>> db  = DbProfile('MP', 'RDxETL', 'prod', 'usfshwssql077')
        >>> db2 = DbProfile('MP', 'RDxETL', 'prod', 'usfshwssql077')
        >>> db3 = DbProfile('CARL', 'RDxETL', 'prod', 'usfshwssql077')
        >>> print db == db
        True
        >>> print db == db2
        True
        >>> print db == db3
        False
        """
        if isinstance(other, self.__class__):
            return self.__dict__ == other.__dict__
        else:
            return False

    def __ne__(self, other):
        return not self.__eq__(other)



    def match_attrib(self, aDict):
        """Does given dict of attib-vals match with self data?
        
        >>> db = DbProfile('MP', 'RDxETL', 'prod', 'usfshwssql077')
        
        Is it dev etl?
        >>> print db.match_attrib(dict(env='dev', dbname='RDxETL'))
        False
        
        Is it MP app prod etl on usfshwssql077?
        >>> print db.match_attrib(dict(app='MP', env='prod', dbname='RDxETL', boxname='usfshwssql077'))
        True
        """
        #print 'Profile {} is trying to match {}'.format(self, aDict)
          
        for k, v in aDict.iteritems():
            if not (vars(self)[k] == v) :
                return False
        return True
        

    def __str__(self):
        """ Doesn't include source and targ paths."""
        return self.app + ' ' + self.dbname + ' ' + self.env + ' ' + self.boxname

    def __repr__(self):
        return str(self.__str__())

if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)    
    #doctest.testfile("tests/test_DbProfile.txt")
    sys.exit(0)
    #sys.exit(main())


    