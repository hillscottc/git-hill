#! /usr/bin/python
"""Uses the ConFigMgr and related classes."""
import sys
import os
import shutil
from ConfigMgr import ConfigMgr
from DbProfile import DbProfile
from DbSet import DbSet
import FileUtils
import argparse

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg


APPS = ('CARL', 'CART', 'Common', 'CPRS', 'CRA', 'CTX', 'D2', 'DRA', 'ELS', 
        'FileService', 'GDRS', 'MP', 'PartsOrder', 'R2')

DBS = (('RDxETL', 'USHPEPVSQL409'),
       ('RDxReport', r'USHPEPVSQL435'))

ENVS = ('dev', )

MODEL_DBSET = DbSet(DbProfile.create_profiles(envs=ENVS, apps=APPS, dbs=DBS)) 

#REMOTE_DIR =  os.path.join(os.getcwd(), 'remote')
REMOTE_DIR =  os.path.join(os.pathsep, 'cygdrive', 'g', 'RDx', 'ETL')

#import pdb; pdb.set_trace()

CHANGE_TO_ENV = 'dev'

# global opts
PATH = REMOTE_DIR
ENV = None
DO_MOD = True
DO_COPY = True
DO_ASK = False             

def main(argv=None):
    try:
        
        #argparser = argparse.ArgumentParser(description='Process args.')
        #argparser.add_argument('-a', action="store_true", default=False)  
        
        # copy remote to work
        if DO_COPY:
            print
            print "Remote PATH '{0}' ...".format(PATH)           
            cm = ConfigMgr(dbset=MODEL_DBSET, path=PATH)
            ms = cm.go(env=CHANGE_TO_ENV)    
            sourcepaths = [k for k, v in ms.matches.iteritems() if len(v) > 0]
            targpaths = [FileUtils.get_work_path(k, REMOTE_DIR) 
                         for k, v in ms.matches.iteritems() if len(v) > 0]    
            print ms.summary_files()
            #print ms.summary_details()
            
            if os.path.exists(ConfigMgr.WORK_DIR) :
                shutil.rmtree(ConfigMgr.WORK_DIR)
                        
            FileUtils.copy_files(sourcepaths, targpaths, DO_ASK)
            print len(sourcepaths), 'file(s) copied to work directory', ConfigMgr.WORK_DIR
        if DO_MOD:        
            print
            print 'Performing file mod...'    
            ms = ConfigMgr(dbset=MODEL_DBSET, path=ConfigMgr.WORK_DIR).go(env=CHANGE_TO_ENV, write=True)     
            print
            print 'Results:'
            print ms.summary_details()
            print
            print ms.summary_matches()
            print
            print "{0:3} files written to dir '{1}'.".format(
                   len(ms.get_new_filenames()), ConfigMgr.OUTPUT_DIR)
                    
        print
        print "Complete."
    except :
        print >>sys.stderr, "Unexpected error:", sys.exc_info()[0]
        raise        
        
     
if __name__ == "__main__":
    sys.exit(main())       
    
