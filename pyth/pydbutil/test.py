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


#print FileUtils.backup('./temp')


#print os.path.basename('./remote/ETL/D2/_log4net.config')

print  FileUtils.get_work_path('./remote/ETL/D2/_log4net.config',
                                './remote', new_dir='work')



print FileUtils.get_newbase('./temp', os.path.join(os.getcwd(), 'bak'))

print FileUtils.get_newbase('/Users/hills/git-hill/pyth/pydbutil/temp',
                            'temp', 'bak'))





# print  FileUtils.get_work_path('./remote/ETL/D2/_log4net.config',
#                                 './remote', new_dir='work')


# l = FileUtils.get_filelist('input/ETL', '.config', '.bat')
# pprint(l)
# print len(l)

# def action(x, y): print(x, y)
# l = FileUtils.walk_wrap('input/ETL', '', action, '.config', '.bat')


#pprint(l)
#print len(l)


#print FileUtils.get_newbase('./temp', os.path.join(os.getcwd(), 'bak'))

    #import pdb; pdb.set_trace()
