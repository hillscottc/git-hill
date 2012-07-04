
""" Sends sql_script and server as args to to a sql batch file which executes a dos sqlcmd.

Usage: 
    py_sqlcmd -p myscript.sql -d 07

Args:
    -p: path to script
    -d: the target db    
    -w: writes output file 
Returns:
Raises:
    IOError: An error occurred the file.
"""

import sys
import getopt
import re
import os

from subprocess import Popen 



class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg


def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(argv[1:], "hp:d:w", ["help", "path=", "db=", "write"])
        except getopt.error, msg:
            raise Usage(msg)

        path = None
        db=None
        write = False
        cmd_params=''
        
        for opt, arg in opts:
            if opt in ("-h", "--help"):
                print __doc__
                sys.exit(0)
            elif opt in ("-p", "--path"):
                path = arg
            elif opt in ("-d", "--database"):
                db = arg
            elif opt in ("-w", "--write"):
                write = True  

        if not path:
            raise Usage('prob wit path')

        if not db:
            raise Usage('prob wit db')
 
        #head, tail = os.path.split(path)

        #from subprocess import Popen 
        #p = Popen(tail, cwd=head)
        #stdout, stderr = p.communicate() 

        params = [path, db]
        print(subprocess.list2cmdline(params)) 
        p = subprocess.Popen(subprocess.list2cmdline(params)) 
        print subprocess.list2cmdline(params) 

        
    except Usage, err:
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:",err.msg
        return 2

if __name__ == "__main__":
    sys.exit(main())

