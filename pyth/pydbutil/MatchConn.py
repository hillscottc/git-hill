#! /usr/bin/python

import sys
from MatchAbstract import MatchAbstract

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

class MatchConn(MatchAbstract):
    """
    
    before and after are instances of dbprofile
    
    """

    def __init__(self, before=None, linenum=None, after=None, newFilename=None):
        self.linenum = linenum
        self.before = before
        self.after = after
        self.newFilename = newFilename


    def is_correct(self):
        """ Does before match before?"""     
        return self.before.match_attrib(dict(env=self.after.env,
                                               dbname=self.after.dbname, 
                                               boxname=self.after.boxname))


    def __str__(self):
        return '{} {} {}'.format(self.before, self.linenum, self.after)

    def __repr__(self):
        return str(self.__str__())

if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    sys.exit(0)
    #sys.exit(main())


    