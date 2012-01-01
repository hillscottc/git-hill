#! /usr/bin/python
"""Uses the ConFigMgr and related classes.
Usage: ./main.py 
Args: 
    -p: path to the remote dir
    -e: the env to switch to {env, uat, or prod}
    -M: do NOT mod files
    -C: do NOT copy files
    -a: ask for user input
"""
import sys
import shutil
import getopt
from ConfigMgr import ConfigMgr
from DbProfile import DbProfile
from DbSet import DbSet
import FileUtils

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg


def create_model_dbset() :
    """Describes the dbset which ConfigMgr uses as model to examine config files.
    """
    # these are on 104
    #APPS = ('CARL', 'Common', 'CPRS', 'CTX', 'D2', 'DRA', 'GDRS', 'MP', 'PartsOrder', 'R2')
    apps = ('CARL', 'CART', 'Common', 'CPRS', 'CRA', 'CTX', 'D2', 'DRA', 'ELS', 'FileService',
            'gdrs', 'MP', 'PartsOrder', 'R2')
        
    # The dbs for each app.
    dbs = (('RDxETL', 'USHPEPVSQL409'), ('RDxReport', r'USFSHWSSQL104\RIGHTSDEV_2'))
    
    # The environs for each for each app+db.
    envs = ('dev',)
    return DbSet(DbProfile.create_profiles(envs=envs, apps=apps, dbs=dbs))


# Create the model dbset to be used for this run.  
MODEL_DBSET = create_model_dbset() 
REMOTE_DIR = 'remote'   

# global opts
PATH = REMOTE_DIR
ENV = None
DO_MOD = True
DO_COPY = True
DO_ASK = False

def parse_opts(argv):
    try:
        opts, args = getopt.getopt(
            argv[1:], "hd:p:e:MCA", ["help", "PATH=", "ENV=", "no_mod", "no_copy", "no_ask"])
    except getopt.error, msg:
        raise Usage(msg)    
    
    for opt, arg in opts :
        if opt in ("-h", "--help"):
            print ConfigMgr.__doc__
            sys.exit(0)
        elif opt in ("-p", "--PATH"):
            PATH = arg
        elif opt in ("-e", "--ENV"):
            ENV = arg
            if ENV != None :
                ENV = ENV.upper()
        elif opt in ("-a", "--ask"):
            DO_ASK = True                  
        elif opt in ("-M", "--no_mod"):
            DO_MOD = False
        elif opt in ("-C", "--no_copy"):
            DO_COPY = False   
                

def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:

        parse_opts(argv) 
      
        # copy remote to work
        if DO_COPY:
            print
            print "Remote PATH '{}' ...".format(PATH)           
            cm = ConfigMgr(dbset=MODEL_DBSET, path=PATH)
            ms = cm.go(env='dev')    
            sourcepaths = [k for k, v in ms.matches.iteritems() if len(v) > 0]
            targpaths = [FileUtils.get_work_path(k, REMOTE_DIR) 
                         for k, v in ms.matches.iteritems() if len(v) > 0]    
            print ms.summary_files()
            #print ms.summary_details()
            shutil.rmtree(ConfigMgr.WORK_DIR)
            FileUtils.copy_files(sourcepaths, targpaths, DO_ASK)
            print len(sourcepaths), 'file(s) copied to work directory', ConfigMgr.WORK_DIR
        if DO_MOD:        
            print
            print 'Performing file mod...'    
            ms = ConfigMgr(dbset=MODEL_DBSET, path=ConfigMgr.WORK_DIR).go(env='dev', write=True)     
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
    except Usage, err:
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:", err.msg
        return 2

        
if __name__ == "__main__":
    sys.exit(main())        