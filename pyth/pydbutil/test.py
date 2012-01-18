#! /usr/bin/python

import re
import os
import FileUtils
from ConfigMgr import ConfigMgr
from pprint import pprint
import time
import logging


pprint(FileUtils.get_filelist('remote', skipdir='Backup'))

pprint(FileUtils.get_filelist('remote'))


