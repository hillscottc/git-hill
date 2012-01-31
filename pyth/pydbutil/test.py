#! /usr/bin/python

import re
import os
from shutil import copytree, rmtree, ignore_patterns
import FileUtils
from ConfigMgr import ConfigMgr
from pprint import pprint
import time
import logging


#pprint(FileUtils.get_filelist('remote', skipdir='Backup'))

# s = './temp'
# t = FileUtils.get_bak_dir(s)
# print s, t

# #FileUtils.backup(s, FileUtils.get_bak_dir(s))

# if os.path.exists(t) :
#     rmtree(t)

# copytree(s, FileUtils.get_bak_dir(s),
#          ignore=ignore_patterns('*.pyc', 'tmp*','Backup*','.git', '.svn'))

FileUtils.backup('./temp', timestamped=False)