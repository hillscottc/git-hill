#! /usr/bin/python
"""Demo of the pydbutil classes.

Usage: 
    ./main.py -d pydbutil/DbSet.data.csv -p pydbutil/test.config   (1 file)
    #./main.py -p /config_dir     (all files named .config in the dir)
    ./main.py -d pydbutil/DbSet.data.csv -p pydbutil/test.config  -e prod
    ./main.py -d pydbutil/DbSet.data.csv -p pydbutil/test.config  -e prod -w    
Args:
    -d: dbsetfile (cvs file)
    -p: targ file or dir
    -e: the env to switch to {env, uat, or prod}    
    -w: writes output file 
Returns:
Raises:
"""

import sys
import os
import getopt
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
                argv[1:], "hd:p:e:w", ["help", "dbsetfile=", "path=", "env=", "write"])
        except getopt.error, msg:
            raise Usage(msg)
        
        dbsetfile = None
        path = None
        env = None
        write = False

        for opt, arg in opts :
            if opt in ("-h", "--help"):
                print __doc__
                sys.exit(0)
            elif opt in ("-d", "--dbsetfile"):
                dbsetfile = arg
            elif opt in ("-p", "--path"):
                path = arg               
            elif opt in ("-e", "--env"):
                env = arg
                if env!=None: env=env.upper()       
            elif opt in ("-w", "--write"):
                write = True                      

        if not os.path.isfile(dbsetfile) :
            raise Usage("Invalid dbsetfile '{}'".format(dbsetfile))
        
        cm = ConfigMgr(cvsfile=dbsetfile)

        filelist = []
        if os.path.isfile(path) :
            filelist = [path]
        elif os.path.isdir(path) :
            #iterate files in specified dir that match *.config        
            for config_file in glob.glob(os.path.join(path,  CONFIG_FILE_EXT)) :
                filelist.append(config_file) 
        else :
            raise Usage("Invalid path '{}'".format(path))
        
        if not write :
            cm.check(*filelist) 
            sys.exit()  
        else:
            if env is None:
                raise Usage('') 

        cm.handle_xml(env, write, *filelist)
        
        print "Complete."
        print
        
    except Usage, err:
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:",err.msg
        return 2

if __name__ == "__main__":
    sys.exit(main())
