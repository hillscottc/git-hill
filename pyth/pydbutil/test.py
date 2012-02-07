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

    #import pdb; pdb.set_trace()


# print FileUtils.get_outfilename('remote', 'work', 'remote/etl/carl/somefile.txt')


# print FileUtils.get_work_path('remote/etl/carl/somefile.txt','remote')


#print FileUtils.backup('/Users/hills/git-hill/pyth/pydbutil', '/Users/hills/Dropbox', '.py', '.config', '.bat')

print os.getcwd()
print os.path.join(os.getcwd(), 'bak')

print FileUtils.backup('/Users/hills/git-hill/pyth/pydbutil', '/Users/hills/Dropbox', '.py')

