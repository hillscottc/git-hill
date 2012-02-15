#! /usr/bin/python

import re
import os
import sys
from shutil import copytree, rmtree, ignore_patterns
import FileUtils
from ConfigMgr import ConfigMgr
from DbSet import DbSet
from ConfigObj import ConfigObj
from pprint import pprint
import time
import logging



path = './remote'
BAKDIR = os.path.join(os.getcwd(), 'bak', 'remote')
FILE_EXTS = ('.config', '.bat')



# sourcepaths = FileUtils.get_filelist(path, *FILE_EXTS)
# #targpaths = [FileUtils.change_root(file, path) for file in sourcepaths]

# pathDict = dict([(s, FileUtils.change_root(s, path, BAKDIR))
#                   for s in sourcepaths])

# pprint(pathDict)
# print len(pathDict)
# print

pathDict =  FileUtils.change_roots(path, os.path.join(os.getcwd(), 'work'), *FILE_EXTS)

pprint(pathDict)
print len(pathDict)
print


# MODEL_DBSET = DbSet.get_dbset('RDxETL')
# print "Using model dbset:"
# pprint(sorted(MODEL_DBSET.DB))


# print
# CONFIGS = ConfigObj.get_configs('RDxETL')
# print 'Searching for configurations:'
# print([co for co in CONFIGS])


# BAKDIR = os.path.join(os.getcwd(), 'bak')






#  #import pdb; pdb.set_trace()
