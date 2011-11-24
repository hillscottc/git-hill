#! /usr/bin/python
"""Usage of the ConFigMgr and related classes. 

Usage: ./main.py -d input/DbSet.data.csv -p input/test.config -e prod -w

Args: (switches for running ConfigMgr.py main)
   -v: verbose test (No other input. Runs the doc tests.)
   -d: dbsetfile (cvs file)     REQUIRED
   -p: path (input file or dir) REQUIRED
   -e: the env to switch to {env, uat, or prod}
   -w: writes output file

Returns:
Raises:
"""
import sys
import os
import getopt
import glob
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
        try:
            opts, args = getopt.getopt(
                argv[1:], "hd:p:e:wv", ["help", "dbsource=", "path=",
                                        "env=", "write", "verbose"])
        except getopt.error, msg:
            raise Usage(msg)

        dbsource = None
        path = None
        env = None
        write = False

        for opt, arg in opts :
            if opt in ("-h", "--help"):
                print ConfigMgr.__doc__
                sys.exit(0)
            elif opt in ("-v", "--verbose"):
                import doctest
                # run both sets of tests.
                doctest.testfile("test_ConfigMgr.txt")
                doctest.testmod(verbose=True)
                sys.exit(0)
            elif opt in ("-d", "--dbsource"):
                dbsource = arg
            elif opt in ("-p", "--path"):
                path = arg
            elif opt in ("-e", "--env"):
                env = arg
                if env!=None: env=env.upper()
            elif opt in ("-w", "--write"):
                write = True


        if (not dbsource) or (not os.path.isfile(dbsource)):
            raise Usage("Invalid dbsource '{}'".format(dbsource))

        cm = ConfigMgr(dbsource=dbsource, write=write)

        filelist = []
        if os.path.isfile(path) :
            filelist = [path]
        elif os.path.isdir(path) :
            #iterate files in specified dir that match *.config
            for config_file in glob.glob(os.path.join(path,  "*.config")) :
                filelist.append(config_file)
        else :
            raise Usage("Invalid path '{}'".format(path))

        if not write :
            cm.check(*filelist)
            sys.exit(0)
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