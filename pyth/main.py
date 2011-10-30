#! /usr/bin/python
""" run my modules."""

import sys
import getopt

class Usage(Exception):
def main(argv=None):
    if argv is None:
         argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(argv[1:], "hi:", ["help"])
        except getopt.error, msg:
            raise Usage(msg)

        for opt, arg in opts :
            if opt in ("-h", "--help"):
                print __doc__
                sys.exit(0)

        print 'Cunning main '

        print 'Create dbprofile from tuple -- {}'.format(
            get_profile_from_tuple(('RDxETL', 'PROD', 'usfshwssql077', r'D:\Something')))

    except Usage, err:
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:",err.msg
        return 2

if __name__ == "__main__":
    sys.exit(main())
