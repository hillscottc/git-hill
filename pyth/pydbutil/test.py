#! /usr/bin/python

import re
import os
import FileUtils
from ConfigMgr import ConfigMgr
from pprint import pformat
import time



#path = './remote/ETL'
path = ConfigMgr.WORK_DIR

print path
print os.path.relpath(path)
t = time.strftime('%m%d%H%M%S')
print os.path.join('bak', t, os.path.relpath(path))


# path = ConfigMgr.WORK_DIR 

# FileUtils.get_bak_dir(path)


# print FileUtils.get_bak_dir('./remote/ETL')
# print ConfigMgr.WORK_DIR
# print FileUtils.get_bak_dir(ConfigMgr.WORK_DIR)




