import sys, getopt, re, os

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

REGEX = re.compile('Data Source=(Usfshwssql\w+);Initial Catalog=(RDx\w+);', re.I)

def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(argv[1:], "hp:w", ["help", "path=", "write"])
        except getopt.error, msg:
            raise Usage(msg)

        path = None
        write = False
        
        for opt, arg in opts:
            if opt in ("-h", "--help"):
                print __doc__
                sys.exit(0)
            elif opt in ("-p", "--path"):
                path = arg                    
            elif opt in ("-w", "--write"):
                write = True  

        if not path:
            raise Usage('prob wit path')
        elif os.path.isfile(path) :
            pass
            #filelist = [path]
        elif os.path.isdir(path) :
            #iterate files in specified dir that match *.config        
            #for config_file in glob.glob(os.path.join(path, '*.config')) :
            #    filelist.append(config_file) 
            pass
        else :
            raise Usage('prob wit path')
        
        print 'you said' , path
        
    except Usage, err:
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:",err.msg
        return 2

if __name__ == "__main__":
    sys.exit(main())

