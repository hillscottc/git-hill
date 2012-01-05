#! /usr/bin/python

import sys

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

class MatchAbstract(object):
    """
    """

    def __init__(self, before=None, linenum=None, after=None, newFilename=None):
        self.linenum = linenum
        self.before = before
        self.after = after
        self.newFilename = newFilename
        

    def is_correct(self):
        """ Does before match before?"""     
        raise NotImplementedError( "Should have implemented this" )     


if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    sys.exit(0)
    #sys.exit(main())


    