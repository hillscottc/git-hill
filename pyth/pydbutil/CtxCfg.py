#! /usr/bin/python
""" Configs the Contraxx apps. """
import os
import re
import shutil
import sys
import pprint
import FileUtils
import getopt



REGEX = '(PARAM_SERVER NAME)=(.+)'



class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

def parse_file(filename):
    """ Returns mclist for the file. """
    with open(filename, 'r') as infile:
        lines = infile.readlines()

    print
    print 'In', filename

    m = None
    for i, line in enumerate(lines):
        m = re.search(REGEX, line, re.IGNORECASE)
        if m:
            print '  On line', str(i),
            print 'found %(param)s pointed to %(val)s' % \
                   {'param':  m.group(1), 'val': m.group(2)}
            break

    if not m:
        print '  No match.'


def main(argv=None):
    """Usage: ./CfxCfg.py -p ./ctx """
    if argv is None:
        argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(argv[1:], "hp:", ["help", "path="])
        except getopt.error, msg:
            raise Usage(msg)

        path = None
        for opt, arg in opts :
            if opt in ("-h", "--help"):
                print __doc__
                sys.exit(0)
            elif opt in ("-p", "--path"):
                path = arg

        if not path :
            raise Usage("option -p is required.")

        print 'Begin.'

        print 'Check path', path

        filelist =  FileUtils.get_filelist(path, '.ini')

        [parse_file(filename) for filename in filelist]

        print 'End.'

    except Usage, err:
        print >>sys.stderr, err.msg
        print >>sys.stderr, "for help use --help"
        return 2

        print >>sys.stderr, "Unexpected error:", sys.exc_info()[0]
        raise


if __name__ == "__main__":
    sys.exit(main())










