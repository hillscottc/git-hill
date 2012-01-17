#! /usr/bin/python

import re
import os
import FileUtils
from ConfigMgr import ConfigMgr
from pprint import pformat
import time
import logging



logging.basicConfig(level=logging.DEBUG,
                    format='%(asctime)s %(name)s %(levelname)-5s %(message)s',
                    datefmt='%m-%d %H:%M',
                    filename='test.log',
                    filemode='w')



