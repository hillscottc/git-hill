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



# print FileUtils.get_outfilename('remote', 'work', 'remote/etl/carl/somefile.txt')


# print FileUtils.get_work_path('remote/etl/carl/somefile.txt','remote')


#print FileUtils.backup('./remote')


print FileUtils.change_base('./temp', os.path.join(os.getcwd(), 'bak'))

