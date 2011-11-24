#! /usr/bin/python
"""Usage of the ConFigMgr and related classes. 


"""
import sys
import os
#import pydbutil.DbSet
#import pydbutil.DbProfile
from ConfigMgr import ConfigMgr

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        
        cm = ConfigMgr(dbsource='input/DbSet.data.csv', path='input/ETL/')
        
        
        match_dict = cm.go()
        print ConfigMgr.match_dict_details(match_dict)
        print ConfigMgr.match_dict_summary(match_dict)
        

        print
        print "Complete."

    except Usage, err:
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:",err.msg
        return 2
        
if __name__ == "__main__":
    sys.exit(main())        