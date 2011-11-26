#! /usr/bin/python
"""Usage of the ConFigMgr and related classes. 


"""
import sys
import os
import shutil
import re
from ConfigMgr import ConfigMgr

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg


# no trail slash for dirs

# FULL path for REMOTE dir only. 
REMOTE_DIR = 'remote'
INPUT_DIR = 'input'
OUTPUT_DIR = 'output'
DBSOURCE = os.path.join('input', 'DbSet.data.csv')

def copy_files(md, test=False):
    for k_file, v_info in md.iteritems():
        if len(v_info) > 1:
            newfile = re.sub(REMOTE_DIR, INPUT_DIR, k_file)
            print 'FROM' , k_file
            print 'TO  ' , newfile
            if not test:
                shutil.copy(k_file, newfile)
                print 'Copied.'     

def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        print
        print "Checking files in remote path '{}' ...".format(REMOTE_DIR)
        print
        cm = ConfigMgr(dbsource=DBSOURCE, path=REMOTE_DIR)
        md = cm.go(verbose=False)     
        print os.linesep.join([str(k) + ' ' + str(v) for k, v in sorted(md.iteritems())])
        print
        print ConfigMgr.match_dict_summary(md)
        print
        print 'Files with NO matches: '
        print os.linesep.join(ConfigMgr.get_match_files(md, False))     
        print 
        print 'So, the copying will be:'
            
        copy_files(md, test=True)
        
        print               
        r = raw_input('Proceed with copy? y/[n] ')
        if not r.lower() == 'y':
            print 'Ok, stopping.'
            sys.exit(0)
        print
        
        copy_files(md)
        print
        print "Complete."

    except Usage, err:
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:",err.msg
        return 2
        
if __name__ == "__main__":
    sys.exit(main())        