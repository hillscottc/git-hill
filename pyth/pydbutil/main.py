#! /usr/bin/python
"""Uses the ConFigMgr and related classes.

Usage: ./main.py -s ./remote [-r]

Args: (switches for running ConfigMgr.py main)
   -h: help
   -s: source path to config files
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


APPS = ('CARL', 'CART', 'Common', 'CPRS', 'CRA', 'CTX', 'D2', 'DRA', 'ELS',
        'FileService', 'GDRS', 'MP', 'PartsOrder', 'R2')

DBS = (('RDxETL', 'USHPEPVSQL409'),
       ('RDxReport', r'USHPEPVSQL435'))

ENVS = ('dev', )

CHANGE_TO_ENV = 'dev'

FILE_EXTS = ('.config', '.bat')

MODEL_DBSET = DbSet(DbProfile.create_profiles(envs=ENVS, apps=APPS, dbs=DBS))

FTP_ROOT = 'USHPEWVAPP251'
LOG_PATH = r'D:\RDx\ETL\logs'
SMTP_SERVER = 'usush-maildrop.amer.umusic.net'
TO_VAL = 'ar.umg.rights.dev@hp.com, Scott.Hill@umgtemp.com'
FROM_VAL = 'RDx@mgd.umusic.com'
SUBJ = 'RDxAlert Message'

CONFIG_OBJS = (ConfigObj('LOG_A', '<file value="(.+)"', LOG_PATH),
                ConfigObj('LOG_B', '"file" value="(.+)"', LOG_PATH),
                ConfigObj('DB', 'Data Source=(.+);Initial Catalog=(RDx\w+);', ''),
                ConfigObj('FTP', r'"(.+)" value="\\\\(.+)\\d\$', FTP_ROOT),
                ConfigObj('TO_VAL', '<to value="(.+)"', TO_VAL),
                ConfigObj('FROM_VAL', '<from value="(.+)"', FROM_VAL),
                ConfigObj('SMTP', '<smtpHost value="(.+)"', SMTP_SERVER),
                ConfigObj('SUBJ', '<subject value="(.+)"', SUBJ))

configs = dict(zip([co.cotype for co in CONFIG_OBJS], CONFIG_OBJS))

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
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s %(name)s %(levelname)-5s %(message)s',
                        datefmt='%m-%d %H:%M',
                        filename='logs/main.log',
                        filemode='w')

    # define a Handler which writes INFO messages or higher to the sys.stderr
    console = logging.StreamHandler()
    console.setLevel(logging.INFO)
    console.setFormatter(logging.Formatter('%(asctime)s %(levelname)-5s %(message)s'))
    # add the handler to the root logger
    logging.getLogger('').addHandler(console)

    logging.info('Begin.')

    if argv is None:
        argv = sys.argv
    try:

        try:
            opts, args = getopt.getopt(
                argv[1:], "hs:r", ["help", "source=", "replace"])
        except getopt.error, msg:
            raise Usage(msg)

        # default value
        source = None
        DO_REPLACE = False

        for opt, arg in opts :
            if opt in ("-h", "--help"):
                print ConfigMgr.__doc__
                sys.exit(0)
            elif opt in ("-s", "--source"):
                source = arg
            elif opt in ("-r", "--replace"):
                DO_REPLACE = True

        if not source :
            raise Usage("option -s is required.")


        # copy remote to work
        if DO_COPY:
            print
            logging.info("Remote PATH %s ...", source)


            filelist = FileUtils.get_filelist(source, *FILE_EXTS)

            targpaths = [FileUtils.get_work_path(f, source) for f in filelist]



            # remove old work dir
            if os.path.exists(ConfigMgr.WORK_DIR) :
                shutil.rmtree(ConfigMgr.WORK_DIR)

            print

            logging.info('Copying %s file(s) to work directory %s',
                         len(filelist), ConfigMgr.WORK_DIR)

            FileUtils.copy_files(filelist, targpaths, DO_ASK)


        if DO_MOD:

            # make a backup work dir
            backupdir = FileUtils.get_bak_dir(ConfigMgr.WORK_DIR)
            logging.info('Backup of work directory created at %s', backupdir)
            shutil.copytree(ConfigMgr.WORK_DIR, backupdir)




            # TRY TO USE THE FILELIST METHOD TO CREATE. CLEARER.
            # new way
            filelist = FileUtils.get_filelist(ConfigMgr.WORK_DIR, *FILE_EXTS)


            cm = ConfigMgr(dbset=MODEL_DBSET, filelist=filelist, configs=configs)
            ms = cm.go(env=CHANGE_TO_ENV, write=True)




            # prev way

            # print
            # logging.info('Performing file mod...')
            # ms = ConfigMgr(dbset=MODEL_DBSET, path=ConfigMgr.WORK_DIR, file_exts=FILE_EXTS,
            #                 configs=configs).go(env=CHANGE_TO_ENV, write=True)
            print
            logging.info('Results:')
            logging.info(ms.summary_details())
            print
            logging.info(ms.summary_matches(configs))
            print
            logging.info("%s files written to dir '%s'.",
                         len(ms.get_work_files(ConfigMgr.WORK_DIR, ConfigMgr.OUTPUT_DIR)),
                         ConfigMgr.OUTPUT_DIR)
            print

            # COPY BACK TO REMOTE
        if DO_REPLACE:
            FileUtils.copy_files(ms.get_work_files(ConfigMgr.WORK_DIR, ConfigMgr.OUTPUT_DIR),
                                 sourcepaths, DO_ASK)
            logging.info('The modified files have been copied back to %s', source)

        print
        logging.info('Complete.')
    except :
        print >>sys.stderr, "Unexpected error:", sys.exc_info()[0]
        raise


if __name__ == "__main__":
    sys.exit(main())

