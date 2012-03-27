#! /usr/bin/python

import os
import sys
from PrintWriter import PrintWriter


pw = PrintWriter(os.path.join("logs", "test.log"))

pw.write("Works?")

# path = './remote'
# BAKDIR = os.path.join(os.getcwd(), 'bak', 'remote')
# FILE_EXTS = ('.config', '.bat')



# sourcepaths = FileUtils.get_filelist(path, *FILE_EXTS)
# #targpaths = [FileUtils.change_root(file, path) for file in sourcepaths]

# pathDict = dict([(s, FileUtils.change_root(s, path, BAKDIR))
#                   for s in sourcepaths])

# pprint(pathDict)
# print len(pathDict)
# print

# pathDict =  FileUtils.change_roots(path, os.path.join(os.getcwd(), 'work'), *FILE_EXTS)

# pprint(pathDict)
# print len(pathDict)
# print


# MODEL_DBSET = DbSet.get_dbset('RDxETL')
# print "Using model dbset:"
# pprint(sorted(MODEL_DBSET.DB))


# print
# CONFIGS = ConfigObj.get_configs('RDxETL')
# print 'Searching for configurations:'
# print([co for co in CONFIGS])


# BAKDIR = os.path.join(os.getcwd(), 'bak')






#  #import pdb; pdb.set_trace()
