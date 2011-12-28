#! /usr/bin/python

import sys


class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

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

    def __len__(self):
        return len(self.DB)

    def get_apps(self):
        return set([prof.app for prof in self.DB])
    
    def get(self, prof):
        """ returns matching profs
        """    
        return self.get_by_atts(vars(prof))
        
    def get_by_atts(self, aDict):
        """Does given dict of attrib-vals match with self data?
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
        return str(self.__str__())


if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    #doctest.testfile("tests/test_DbSet.txt", verbose=True)
    sys.exit(0)

