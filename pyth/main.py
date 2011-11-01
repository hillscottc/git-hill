#! /usr/bin/python
"""Demo of the pydbutil classes. 
Usage: ./main.py
Args:
Returns:
Raises:
"""
import sys
import os
import getopt
import glob
from pydbutil.ConfigMgr import ConfigMgr

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(
                argv[1:], "h", ["help"])
        except getopt.error, msg:
            raise Usage(msg)

        for opt, arg in opts :
            if opt in ("-h", "--help"):
                print __doc__
                sys.exit(0)
  
        # What do do here? Maybe just run tests?
        #doctest.testmod(ConfigMgr)
        
        import doctest
        doctest.testfile("pydbutil/test_pydbutil.txt")
  
        print "Complete."
        print
        
    except Usage, err:
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:",err.msg
        return 2

if __name__ == "__main__":
    sys.exit(main())
