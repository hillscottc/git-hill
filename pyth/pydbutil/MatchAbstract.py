#! /usr/bin/python

import sys

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

class MatchAbstract(object):

    def __init__(self, before=None, linenum=None, after=None, newFilename=None):
        self.linenum = linenum
        self.before = before
        self.after = after
        self.newFilename = newFilename
        
    
    def is_correct(self):
        """ Does before match before?"""     
        if self.before.upper() == self.after.upper() :
            return True
        else :
            return False     
        
    def __str__(self):
        return '{} {} {}'.format(self.before, self.linenum, self.after)

    def __repr__(self):
        return str(self.__str__())

if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    sys.exit(0)
    #sys.exit(main())


    