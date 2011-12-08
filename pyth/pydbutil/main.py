#! /usr/bin/python
"""Uses the ConFigMgr and related classes.

Usage:
    ./main.py 

Args: 
    -p: path to the remote dir
    -e: the env to switch to {env, uat, or prod}
    -M: do NOT mod files
    -C: do NOT copy files
    -A: do NOT ask user for input

"""
import sys
import os
import getopt
import shutil
import re
from ConfigMgr import ConfigMgr
from MatchSet import MatchSet
import FileUtils


class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

# The source PATH to the files to be worked on.
# Samples are in 'remote' 
REMOTE_DIR = 'remote'

# Data file of app database connections by environment.
DBSOURCE = os.path.join('input', 'DbSet.data.csv')

def get_work_path(path, old_dir=None, new_dir=None):
    if not old_dir:
        old_dir = REMOTE_DIR
    if not new_dir:
        new_dir = ConfigMgr.WORK_DIR
    
    return re.sub(old_dir, new_dir, path)                             

def ensure_dir(f):
    d = os.path.dirname(f)
    if not os.path.exists(d):
        os.makedirs(d)

def copy_files(sourcepaths, targpaths, ask=True):
    print 'The copying will be:'         
    print os.linesep.join(map('FROM {}\nTO   {}'.format, sourcepaths, targpaths))   
    print
    if ask:
        r = raw_input('Proceed with copy? [y]/n ')
        if r.lower() == 'n':
            print 'Ok, stopping.'
            sys.exit(0)
    [ensure_dir(f) for f in targpaths]
    map(shutil.copy, sourcepaths, targpaths)
    print len(sourcepaths), 'file(s) copied.'

def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(
                argv[1:], "hd:p:e:MCA", ["help", "path=", "env=", "no_mod", "no_copy", "no_ask"])
        except getopt.error, msg:
            raise Usage(msg)

        path = REMOTE_DIR
        env = None
        do_mod = True
        do_copy = True
        do_ask = True

        for opt, arg in opts :
            if opt in ("-h", "--help"):
                print ConfigMgr.__doc__
                sys.exit(0)
            elif opt in ("-p", "--path"):
                path = arg
            elif opt in ("-e", "--env"):
                env = arg
                if env!=None: env=env.upper()
            elif opt in ("-M", "--no_mod"):
                do_mod = False
            elif opt in ("-C", "--no_copy"):
                do_copy = False             
            elif opt in ("-A", "--no_ask"):
                do_ask = False        
        print
        print "Checking files in remote path '{}' ...".format(path)
        print
        cm = ConfigMgr(dbsource=DBSOURCE, path=path)
        ms = cm.go(env='dev')    
        print
    
        sourcepaths = [k for k, v in ms.matches.iteritems() if len(v) > 1]
        targpaths = [get_work_path(k) for k, v in ms.matches.iteritems() if len(v) > 1]
        
        # copy remote to work
        if do_copy:
            copy_files(sourcepaths, targpaths, do_ask)
        
        if do_mod:        
            print
            print 'Performing file mod...'    
            ms = ConfigMgr(dbsource=DBSOURCE, path=ConfigMgr.WORK_DIR).go(env='dev', write=True)     
            print
            print "Scanning output directory..."
            print
            ms = ConfigMgr(dbsource=DBSOURCE, path=ConfigMgr.OUTPUT_DIR).go(env='dev')     
            #print ms.match_dict_summary()  
            print    
            
#        # copy output back to remote
#        if do_copy:
#            copy_files(targpaths, sourcepaths, do_ask)            
            
        print
        print "Complete."
    except Usage, err:
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:", err.msg
        return 2

        
if __name__ == "__main__":
    sys.exit(main())        