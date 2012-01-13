#! /usr/bin/python
"""Uses the ConFigMgr and related classes.

Usage: ./main.py -s ./remote

Args: (switches for running ConfigMgr.py main)
   -h: help
   -s: source path to config files

   
"""
import sys
import os
import shutil
from ConfigMgr import ConfigMgr
from DbProfile import DbProfile
from DbSet import DbSet
import FileUtils
import getopt

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg


APPS = ('CARL', 'CART', 'Common', 'CPRS', 'CRA', 'CTX', 'D2', 'DRA', 'ELS', 
        'FileService', 'GDRS', 'MP', 'PartsOrder', 'R2')

DBS = (('RDxETL', 'USHPEPVSQL409'),
       ('RDxReport', r'USHPEPVSQL435'))

ENVS = ('dev', )

CHANGE_TO_ENV = 'dev'

MODEL_DBSET = DbSet(DbProfile.create_profiles(envs=ENVS, apps=APPS, dbs=DBS)) 

#REMOTE_DIR =  os.path.join(os.getcwd(), 'remote')
#REMOTE_DIR =  os.path.join( '/cygdrive', 'g', 'RDx', 'ETL')


# global opts
#PATH = REMOTE_DIR
ENV = None
DO_MOD = True
DO_COPY = True
DO_ASK = False             

def main(argv=None):
    if argv is None:
        argv = sys.argv    
    try:
        
        try:
            opts, args = getopt.getopt(
                argv[1:], "hs:", ["help", "source="])
        except getopt.error, msg:
            raise Usage(msg)
        
        # default value
        source = None

        for opt, arg in opts :
            if opt in ("-h", "--help"):
                print ConfigMgr.__doc__
                sys.exit(0)
            elif opt in ("-s", "--source"):
                source = arg
     
        if not source :
            raise Usage("option -s is required.")
        
                
        # copy remote to work
        if DO_COPY:
            print
            print "Remote PATH '{0}' ...".format(source)         
            
            # BACKUP REMOTE FILES
            backup = source + '_bak'
            if os.path.exists(backup) :
                shutil.rmtree(backup)      
            print 'Backing up {0} to {1}'.format(source, backup)
            shutil.copytree(source, backup)            
            print       
                 
            # Call mgr without write, to get summaries                  
            cm = ConfigMgr(dbset=MODEL_DBSET, path=source)
            ms = cm.go(env=CHANGE_TO_ENV)    
            sourcepaths = [k for k, v in ms.matches.iteritems() if len(v) > 0]
            targpaths = [FileUtils.get_work_path(k, source) 
                         for k, v in ms.matches.iteritems() if len(v) > 0]    
            print ms.summary_files()
                

        if DO_MOD:   
            print
            # COPY FROM REMOTE TO WORK             
            if os.path.exists(ConfigMgr.WORK_DIR) :
                shutil.rmtree(ConfigMgr.WORK_DIR)                 
            print 'Copying {0} file(s) to work directory {1}'.format(
                    len(sourcepaths), ConfigMgr.WORK_DIR)            
            FileUtils.copy_files(sourcepaths, targpaths, DO_ASK)     
                 
            print
            print 'Performing file mod...'    
            ms = ConfigMgr(dbset=MODEL_DBSET, path=ConfigMgr.WORK_DIR
                           ).go(env=CHANGE_TO_ENV, write=True)     
            print
            print 'Results:'
            print ms.summary_details()
            print
            print ms.summary_matches()
            print
            print "{0:3} files written to dir '{1}'.".format(
                   len(ms.get_work_files(ConfigMgr.WORK_DIR, ConfigMgr.OUTPUT_DIR)),
                   ConfigMgr.OUTPUT_DIR)
            print
            
            
         
                          
            
            # COPY BACK TO REMOTE      
                  
            FileUtils.copy_files(ms.get_work_files(ConfigMgr.WORK_DIR, ConfigMgr.OUTPUT_DIR),
                                 sourcepaths, DO_ASK)
            print 'The modified files have been copied back to', source
                    
        print
        print "Complete."
    except :
        print >>sys.stderr, "Unexpected error:", sys.exc_info()[0]
        raise        
        
     
if __name__ == "__main__":
    sys.exit(main())       
    
