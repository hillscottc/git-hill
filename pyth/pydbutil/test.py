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

src = '/Users/hills/git-hill/pyth/pydbutil/temp'
dst = '/Users/hills/Dropbox'
extentions =  ('.py', '.config', '.bat')

files = FileUtils.walk_wrap(src, dst, *extentions)


pprint(files)


# src = './temp/test.config'
# print os.path.basename(src), os.path.dirname(src)


# print len(srclist)

# pprint(dstlist)
# print len(dstlist)

#pprint(FileUtils.get_filelist('remote', skipdir='Backup'))

# s = './temp'
# t = FileUtils.get_bak_dir(s)
# print s, t

#import pdb; pdb.set_trace()


# print FileUtils.get_outfilename('remote', 'work', 'remote/etl/carl/somefile.txt')


# print FileUtils.get_work_path('remote/etl/carl/somefile.txt','remote')


#print FileUtils.backup('/Users/hills/git-hill/pyth/pydbutil', '/Users/hills/Dropbox', '.py', '.config', '.bat')

# print os.getcwd()
# print os.path.join(os.getcwd(), 'bak')

# print FileUtils.backup('/Users/hills/git-hill/pyth/pydbutil', '/Users/hills/Dropbox', '.py')

# path = './remote'

# sourcepaths = FileUtils.get_filelist(path, '.config', '.bat')
# print len(sourcepaths)

# targpaths = [FileUtils.get_work_path(file, path) for file in sourcepaths]
# print len(targpaths)

# sourcepaths = FileUtils.walk_wrap(path, './work', .config', '.bat')
# print len(sourcepaths)

#FileUtils.backup('./temp')
# dst = '/Users/hills/git-hill/pyth/pydbutil/temp/bak/temp'



 #import pdb; pdb.set_trace()
