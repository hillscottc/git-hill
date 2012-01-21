#! /usr/bin/python

import sys

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

class MatchedConfig(object):
    def __init__(self, mtype=None, before=None, linenum=None, after=None,
                 newname=None, before_raw=None):
        self.mtype = mtype
        self.before = before
        self.linenum = linenum
        self.after = after
        self.newname = newname
        self.before_raw = before_raw
        
    def is_correct(self):
        """ Does before match before?"""     
        if self.before.upper() == self.after.upper() :
            return True
        else :
            return False
    
    
    
    def __str__(self):
        return 'mt:{0} b:{1} l:{2} a:{3} n:{4}'.format(
                self.mtype, self.before,self.linenum, self.after, self.newname)
    
    def __repr__(self):
        return str(self.__str__())




if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    sys.exit(0)
    #sys.exit(main())


    