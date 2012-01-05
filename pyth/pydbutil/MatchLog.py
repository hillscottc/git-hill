#! /usr/bin/python

import sys
from MatchAbstract import MatchAbstract

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

class MatchLog(MatchAbstract):
    """before and after are the log location strs."""
    
    def __init__(self, before=None, linenum=None, after=None, newFilename=None):
        super(MatchLog, self).__init__(before, linenum, after, newFilename)

    def is_correct(self):
        return super(MatchLog, self).is_correct()

    def __str__(self):
        return super(MatchLog, self).__str__()

    def __repr__(self):
        return super(MatchLog, self).__repr__()

if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    sys.exit(0)
    #sys.exit(main())


    