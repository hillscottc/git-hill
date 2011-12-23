#! /usr/bin/python

import sys

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

class ConnMatchInfo(object):
    """
    >>> cmi = ConnMatchInfo(DbProfile(dbname='RDxETL', boxname='USHPEPVSQL409', app='MP', env='dev'), 6, DbProfile(dbname='RDxETL', boxname='USHPEPVSQL409', app='MP', env='dev'))
    >>> cmi.is_correct()
    True
    >>> cmi.suggProf = DbProfile(dbname='RDxETL', boxname='USHHWSSSQL077', app='MP', env='dev')
    >>> cmi.is_correct()
    False
    """

    def __init__(self, matchProf, linenum, suggProf=None):
        self.linenum = linenum
        self.matchProf = matchProf
        self.suggProf = suggProf


    def is_correct(self):
        """ Does matchProf match matchProf?"""     
        return self.matchProf.match_attrib(dict(env=self.suggProf.env,
                                               dbname=self.suggProf.dbname, 
                                               boxname=self.suggProf.boxname))


    def __str__(self):
        return '{} {} {}'.format(self.boxname, self.dbname, self.linenum)

    def __repr__(self):
        return str(self.__str__())

if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    sys.exit(0)
    #sys.exit(main())


    