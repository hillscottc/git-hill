#! /usr/bin/python

import sys
from MatchAbstract import MatchAbstract

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

class MatchFtp(MatchAbstract):
    """before and after are the ftp filepaths"""

    def __init__(self, before=None, linenum=None, after=None, newFilename=None, ftpname=None):
        super(MatchFtp, self).__init__(before, linenum, after, newFilename)
        self.ftpname = ftpname

    def is_correct(self):
        return super(MatchFtp, self).is_correct()

    def __str__(self):
        return super(MatchFtp, self).__str__()

    def __repr__(self):
        return super(MatchFtp, self).__repr__()

if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    sys.exit(0)
    #sys.exit(main())


    