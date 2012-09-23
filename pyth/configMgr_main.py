#! /usr/bin/python
"""
Uses the pydbutil classes.

Returns:
Raises:
"""
import sys
import os
import getopt
import logging
import pprint
import shutil
import pydbutil.FileUtils
from pydbutil.ConfigMgr import ConfigMgr
from pydbutil.DbProfile import DbProfile
from pydbutil.DbSet import DbSet
from pydbutil.ConfigObj import ConfigObj

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
DO_COPY = True
DO_MOD = True
DO_ASK = False

def main(argv=None):
    pass

if __name__ == "__main__":
    sys.exit(main())
