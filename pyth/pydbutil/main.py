#! /usr/bin/python
""" Uses the ConFigMgr and related classes to parse and mod config files.

See the Configure.py module for most of the app's configuration.
"""
import sys
import os
import shutil
from ConfigMgr import ConfigMgr
from DbProfile import DbProfile
from DbSet import DbSet
from ConfigObj import ConfigObj
import FileUtils
import getopt
import logging
import pprint
import Configure
import MatchReport

DO_COPY = True
DO_MOD = True
DO_ASK = False

print
print 'MODULE CONFIGURATION:'
pp = pprint.PrettyPrinter(indent=4)
pp.pprint('Handling file extensions: {0}'.format(str(Configure.FILE_EXTS)))
print
print "Using model dbset:"
pp.pprint(sorted(Configure.DBSET.DB))
print
pp.pprint('Searching for configurations:')
pp.pprint([co for co in Configure.CONFIGS])
print
#import pdb; pdb.set_trace()

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg


def main(argv=None):
    """Uses the ConFigMgr and related classes.

    Usage: ./main.py -p ./remote [-r]

    Args: (switches for running ConfigMgr.py main)
       -h: help
       -p: path to config files to be changed
       -r: replace orig with modified files
    """

    # set log file
    logpathname = os.path.join(os.getcwd(), 'logs', 'pydbutil.main.log')
    logging.basicConfig(level=logging.DEBUG,
                        format='%(asctime)s %(name)s %(levelname)-5s %(message)s',
                        datefmt='%m-%d %H:%M',
                        filename=logpathname,
                        filemode='w')

    print 'BEGIN.'

    if argv is None:
        argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(
                argv[1:], "hp:r", ["help", "path=", "replace"])
        except getopt.error, msg:
            raise Usage(msg)

        # default value
        path = None
        DO_REPLACE = False

        for opt, arg in opts :
            if opt in ("-h", "--help"):
                print __doc__
                sys.exit(0)
            elif opt in ("-p", "--path"):
                path = arg
            elif opt in ("-r", "--replace"):
                DO_REPLACE = True

        if not path :
            raise Usage("option -p is required.")


        # copy remote to work
        if DO_COPY:
            print

            # remove old work dir
            if os.path.exists(ConfigMgr.WORK_DIR) :
                shutil.rmtree(ConfigMgr.WORK_DIR)

            shutil.copytree(path, ConfigMgr.WORK_DIR)

            print "Copied from {0} to {1}".format(path, ConfigMgr.WORK_DIR)

        if DO_MOD:

            workfiles = FileUtils.get_filelist(ConfigMgr.WORK_DIR, *Configure.FILE_EXTS)

            cm = ConfigMgr(dbset=Configure.DBSET, filelist=workfiles, configs=Configure.CONFIGS)
            md = cm.go(write=True)

            print
            print 'Results:'
            print MatchReport.details(md, apps=Configure.APPS)
            print MatchReport.summary(md, Configure.CONFIGS)
            print
            print "{0} files written to dir '{1}'.".format(
                   FileUtils.filecount(ConfigMgr.OUTPUT_DIR), ConfigMgr.OUTPUT_DIR)
            print
            print 'Match results written to', logpathname

            #logging.info(ms.summary_details(apps=Configure.APPS))
            #logging.info(ms.summary_matches(Configure.CONFIGS))

            # COPY BACK TO REMOTE
        if DO_REPLACE:
            print "Unimplemented."


        print
        print 'END.'
    except Usage, err:
        print >>sys.stderr, err.msg
        print >>sys.stderr, "for help use --help"
        return 2

        print >>sys.stderr, "Unexpected error:", sys.exc_info()[0]
        raise


if __name__ == "__main__":
    sys.exit(main())

