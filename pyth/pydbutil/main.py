#! /usr/bin/python
"""Uses the ConFigMgr and related classes.

Usage:
    ./main.py 

Args: 
    -p: path to the remote dir
    -e: the env to switch to {env, uat, or prod}
    -M: do NOT mod files
    -C: do NOT copy files
    -a: ask for user input

"""
import sys
import getopt
from ConfigMgr import ConfigMgr
from DbProfile import DbProfile
from DbSet import DbSet
import FileUtils

REMOTE_DIR = 'remote'


class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

def create_model_dbset() :
    """Describes the dbset which ConfigMgr uses as model to examine config files.
    """
    # these are on 104
    #APPS = ('CARL', 'Common', 'CPRS', 'CTX', 'D2', 'DRA', 'GDRS', 'MP', 'PartsOrder', 'R2')
    apps = ('CARL', 'CART', 'Common', 'CPRS', 'CRA', 'CTX', 'D2', 'DRA', 'ELS', 'FileService' , 'gdrs', 'MP', 'PartsOrder', 'R2')
        
    # The dbs for each app.
    dbs = (
           ('RDxETL', 'USHPEPVSQL409'),
           ('RDxReport', r'USFSHWSSQL104\RIGHTSDEV_2')
          )
    
    # The environs for each for each app+db.
    envs = ('dev',)
    
    return DbSet(DbProfile.create_profiles(envs=envs, apps=apps, dbs=dbs))

# Create the model dbset to be used for this run.  
MODEL_DBSET = create_model_dbset() 
    
def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(
                argv[1:], "hd:p:e:MCA", ["help", "path=", "env=", "no_mod", "no_copy", "no_ask"])
        except getopt.error, msg:
            raise Usage(msg)

        path = REMOTE_DIR
        env = None
        do_mod = True
        do_copy = True
        do_ask = False

        for opt, arg in opts :
            if opt in ("-h", "--help"):
                print ConfigMgr.__doc__
                sys.exit(0)
            elif opt in ("-p", "--path"):
                path = arg
            elif opt in ("-e", "--env"):
                env = arg
                if env != None :
                    env=env.upper()
            elif opt in ("-a", "--ask"):
                do_ask = True                  
            elif opt in ("-M", "--no_mod"):
                do_mod = False
            elif opt in ("-C", "--no_copy"):
                do_copy = False             
      
        # copy remote to work
        if do_copy:
            print
            print "Remote path '{}' ...".format(path)           
            cm = ConfigMgr(dbset=MODEL_DBSET, path=path)
            ms = cm.go(env='dev')    
            sourcepaths = [k for k, v in ms.matches.iteritems() if len(v) > 0]
            targpaths = [FileUtils.get_work_path(k, REMOTE_DIR) for k, v in ms.matches.iteritems() if len(v) > 0]    
            print ms.summary_files()
            #print ms.summary_details()
            FileUtils.copy_files(sourcepaths, targpaths, do_ask)
            print len(sourcepaths), 'file(s) copied to work directory', ConfigMgr.WORK_DIR
        if do_mod:        
            print
            print 'Performing file mod...'    
            ms = ConfigMgr(dbset=MODEL_DBSET, path=ConfigMgr.WORK_DIR).go(env='dev', write=True)     
            print
            print 'Results:'
            print ms.summary_details()
            print
            print ms.summary_matches()
            print
            print "{0:3} files written to dir '{1}'.".format(len(ms.get_new_filenames()), ConfigMgr.OUTPUT_DIR)
            
            
#            print 'test'
#            p = DbProfile('CPRS', 'RDxETL', 'dev', 'USHPEPVSQL409')
#            print p.match_attrib(dict(env='dev', dbname='RDxETL'))
#            cm = ConfigMgr(dbset=DBSET, path=path)
#            print cm.dbset.get(p)
        
                
        print
        print "Complete."
    except Usage, err:
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:", err.msg
        return 2

        
if __name__ == "__main__":
    sys.exit(main())        