#! /usr/bin/python
"""Uses the ConFigMgr and related classes.

Usage: ./main.py -p ./remote [-r]

Args: (switches for running ConfigMgr.py main)
   -h: help
   -p: path to config files to be changed
   -r: replace orig with modified files
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

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg


CHANGE_TO_ENV = 'dev'

FILE_EXTS = ('.config', '.bat')

MODEL_DBSET = DbSet.get_dbset('RDxETL')
CONFIGS = ConfigObj.get_configs('RDxETL')

#REMOTE_DIR =  os.path.join(os.getcwd(), 'remote')
#REMOTE_DIR =  os.path.join( '/cygdrive', 'g', 'RDx', 'ETL')

# global opts
#PATH = REMOTE_DIR
ENV = None
DO_COPY = True
DO_MOD = True
DO_ASK = False

def main(argv=None):

    # set log file
    logpathname = os.path.join(os.getcwd(), 'logs', 'main.log')
    logging.basicConfig(level=logging.DEBUG,
                        format='%(asctime)s %(name)s %(levelname)-5s %(message)s',
                        datefmt='%m-%d %H:%M',
                        filename=logpathname,
                        filemode='w')

    print 'Begin.'

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
            print "Remote PATH {0} ...".format(path)
            sourcepaths = FileUtils.get_filelist(path, *FILE_EXTS)
            targpaths = [FileUtils.get_work_path(file, path) for file in sourcepaths]
            # remove old work dir
            if os.path.exists(ConfigMgr.WORK_DIR) :
                shutil.rmtree(ConfigMgr.WORK_DIR)
            print
            print 'Copying {0} file(s) to work directory {1}'.format(
                   len(sourcepaths), ConfigMgr.WORK_DIR)

            FileUtils.copy_files(sourcepaths, targpaths, DO_ASK)

        if DO_MOD:

            # make a backup work dir
            backupdir = FileUtils.get_bak_dir(ConfigMgr.WORK_DIR)
            print 'Backup of work directory created at {0}'.format(backupdir)
            shutil.copytree(ConfigMgr.WORK_DIR, backupdir)

            workfiles = FileUtils.get_filelist(ConfigMgr.WORK_DIR, *FILE_EXTS)

            cm = ConfigMgr(dbset=MODEL_DBSET, filelist=workfiles, configs=CONFIGS)
            ms = cm.go(env=CHANGE_TO_ENV, write=True)

            print
            print 'Results:'
            print ms.summary_matches(CONFIGS)
            print
            print "{0} files written to dir '{1}'.".format(
                    len(ms.get_work_files(ConfigMgr.WORK_DIR, ConfigMgr.OUTPUT_DIR)),
                    ConfigMgr.OUTPUT_DIR)
            print
            print 'Match results written to', logpathname
            logging.info(ms.summary_details())

            # COPY BACK TO REMOTE
        if DO_REPLACE:
            print "Preparing to copy modified files back to source."
            FileUtils.copy_files(targpaths, sourcepaths, DO_ASK)

            print 'The modified files have been copied back to {0}'.format(path)

        print
        print 'Complete.'
    except Usage, err:
        print >>sys.stderr, err.msg
        print >>sys.stderr, "for help use --help"
        return 2

        print >>sys.stderr, "Unexpected error:", sys.exc_info()[0]
        raise


if __name__ == "__main__":
    sys.exit(main())

