#! /usr/bin/python

import re
import os
import FileUtils
from ConfigMgr import ConfigMgr
from pprint import pprint
import time
import logging


#pprint(FileUtils.get_filelist('remote', skipdir='Backup'))

paths = ['./remote', './remote/']

for path in paths:
    print FileUtils.get_bak_dir(path, False)
    print FileUtils.get_bak_dir(path)




