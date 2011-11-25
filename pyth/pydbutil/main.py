#! /usr/bin/python
"""Usage of the ConFigMgr and related classes. 


"""
import sys
import os
from ConfigMgr import ConfigMgr

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg



REMOTE_DIR = 'remote/ETL'
INPUT_DIR = 'input/ETL'
OUTPUT_DIR = 'output'
DBSOURCE = os.path.join('input', 'DbSet.data.csv')

def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        print 'Check remote path.'
        cm = ConfigMgr(dbsource=DBSOURCE, path=REMOTE_DIR)
        match_dict = cm.go(verbose=False)     
        
        print 'Match details for:', REMOTE_DIR 
        print ConfigMgr.match_dict_details(match_dict)
        print
        print 'Files with NO matches: '
        print ConfigMgr.match_dict_files(match_dict, with_matches=False)        
               
#        r = raw_input('Copy these files to {}? y/[n] '.format(INPUT_DIR))
#        if not r.lower() == 'y':
#            print 'Ok, stopping.'
#            sys.exit(0)
        
        
        

        print
        print "Complete."

    except Usage, err:
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:",err.msg
        return 2
        
if __name__ == "__main__":
    sys.exit(main())        