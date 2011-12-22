#! /usr/bin/python
"""A conn match with the match and the suggested fix. 


"""
import sys
#from ConnMatchInfo import ConnMatchInfo

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

class MatchData(object):
    """
    Usage:
    >>> m = MatchData('s')
    >>> m.is_correct()
    False
    >>> m = MatchData('s', 'S')
    >>> m.is_correct()
    True
    >>> m = MatchData('x', 'y')
    >>> m.is_correct()
    False
    """  
    def __init__(self, matchVal, suggVal=None):
        self.matchVal = matchVal
        self.suggVal = suggVal
        
    def is_correct(self):
        if (self.matchVal and self.suggVal and
            (self.matchVal.lower() == self.suggVal.lower())):
                return True
        else : return False

if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    sys.exit(0)

