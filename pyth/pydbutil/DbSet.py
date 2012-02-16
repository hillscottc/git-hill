#! /usr/bin/python

import sys
from DbProfile import DbProfile



class DbSet(object):
    """Manages database profiles. cvsfile is an option for input. maybe i dont need?
    Defaults work well.
    Usage:
    >>> dbset = DbSet(apps=('CARL', 'MP'), dbs=(('RDxETL', 'USHPEPVSQL409'), ('RDxReport', 'USHPEPVSQL409')))
    >>> print len(dbset)
    4
    """

    DB = []

    def __init__(self, profs):
        self.DB = profs

    APPS = ('CARL', 'CART', 'Common', 'CPRS', 'CRA', 'CTX', 'D2', 'DRA',
                        'ELS', 'FileService', 'GDRS', 'MP', 'PartsOrder', 'R2')

    @staticmethod
    def get_dbset(configset='RDxETL'):
        """ Returns dbset for configset set. """
        if configset == 'RDxETL' :
            DBS = (('RDxETL', 'USHPEPVSQL409'), ('RDxReport', r'USHPEPVSQL435'))
            ENVS = ('dev', )
            return DbSet(DbProfile.create_profiles(envs=ENVS, apps=DbSet.APPS, dbs=DBS))

        else:
            raise Exception('Invalid configset', configset)

    def __len__(self):
        return len(self.DB)

    def get_apps(self):
        """ Returns: set of apps in the current DB profiles. """
        return set([prof.app for prof in self.DB])

    def get(self, prof):
        """ Returns:  matching profs """
        return self.get_by_atts(vars(prof))

    def get_by_atts(self, aDict):
        """Returns: Profiles that have attributes matching the given set.
        Usage:
        >>> dbset = DbSet(apps=('CARL', 'MP'), dbs=(('RDxETL', 'USHPEPVSQL409'), ('RDxReport', 'USHPEPVSQL409')))

        Have any CARL RDxETL?
        >>> print dbset.get_by_atts(dict(app='CARL', dbname='RDxETL'))
        [CARL RDxETL dev USHPEPVSQL409]
        """

        profiles = []
        for dbprof in self.DB:
            if dbprof.match_attrib(aDict):
                profiles.append(dbprof)
        return profiles

    def __str__(self):
        return str([str(dbprofile) for dbprofile in self.DB])

    def __repr__(self):
        return str(['{0:30}'.format(dbprofile) for dbprofile in self.DB])


if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    #doctest.testfile("tests/test_DbSet.txt", verbose=True)
    sys.exit(0)

