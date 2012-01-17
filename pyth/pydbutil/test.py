#! /usr/bin/python

import re
import os
import time

time_str = '_' + time.strftime('%m%d%H%M%S') + '_BAK'


head, tail = os.path.split(path)

newname = os.path.join(head, tail + time_str)

print newname

#filename = "%s_%d%s" % (base_name, str(time.strftime('%Y_%m_%d_%H_%M_%S')), ext)






