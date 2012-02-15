#! /usr/bin/python

import re
import os
import sys
from shutil import copytree, rmtree, ignore_patterns
import FileUtils
from ConfigMgr import ConfigMgr
from pprint import pprint
import time
import logging


#FileUtils.backup('/Users/hills/git-hill/pyth/pydbutil', '/Users/hills/Dropbox', '.py', '.config', '.bat')

# src = '/Users/hills/git-hill/pyth/pydbutil/temp'
# dst = '/Users/hills/git-hill/pyth/pydbutil/bak'
# #extentions =  ('.config')

BAKDIR = os.path.join(os.getcwd(), 'bak')

FileUtils.backup(ConfigMgr.WORK_DIR, BAKDIR)

# FileUtils.backup(src, dst)

path = './remote'
FILE_EXTS = ('.config', '.bat')

sourcepaths = FileUtils.get_filelist(path, *FILE_EXTS)
#targpaths = [FileUtils.change_root(file, path) for file in sourcepaths]

pathDict = dict([(s, FileUtils.change_root(s, path))
                  for s in sourcepaths])

pprint(pathDict)
pprint(dict([(t, s)for s, t in pathDict.iteritems()]))

# FileUtils.copy_files(pathDict, True)

# print sorted(k for k, v in pathDict.iteritems())

# print

# print sorted(v for k, v in pathDict.iteritems())

# print len(pathDict)

# FileUtils.copy_files(dict([(t, s)for s, t in pathDict.iteritems()]), True)

#  #import pdb; pdb.set_trace()
