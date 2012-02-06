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


#pprint(FileUtils.get_filelist('remote', skipdir='Backup'))

# s = './temp'
# t = FileUtils.get_bak_dir(s)
# print s, t

# #FileUtils.backup(s, FileUtils.get_bak_dir(s))

# if os.path.exists(t) :
#     rmtree(t)

# copytree(s, FileUtils.get_bak_dir(s),
#          ignore=ignore_patterns('*.pyc', 'tmp*','Backup*','.git', '.svn'))

#print os.getcwd()

logpathname = os.path.join(os.getcwd(), 'logs', 'test.log')
logging.basicConfig(level=logging.DEBUG,
                    format='%(asctime)s %(name)s %(levelname)-5s %(message)s',
                    datefmt='%m-%d %H:%M',
                    filename=logpathname,
                    filemode='w')

FILE_EXTS = ('.config', '.bat')
src, dst = './temp', os.getcwd()



FileUtils.backup(src, dst, '.config', '.bat')

#FileUtils.backup(src)
