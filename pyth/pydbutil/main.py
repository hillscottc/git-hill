#! /usr/bin/python
"""Uses the ConFigMgr and related classes.

Usage:
    ./main.py 

Args: 
    -p: path to the remote dir
    -e: the env to switch to {env, uat, or prod}
    -M: do NOT mod files
    -C: do NOT copy files
    -A: do NOT ask user for input

"""
import sys
import os
import getopt
import re
from ConfigMgr import ConfigMgr
from DbProfile import DbProfile
from DbSet import DbSet
from collections import namedtuple
import FileUtils

REMOTE_DIR = 'remote'

# these are on 104
#APPS = ('CARL', 'Common', 'CPRS', 'CTX', 'D2', 'DRA', 'GDRS', 'MP', 'PartsOrder', 'R2')
APPS = ('CARL', 'CART', 'Common', 'CPRS', 'CRA', 'CTX', 'D2', 'DRA', 'ELS', 'FileService' , 'gdrs', 'MP', 'PartsOrder', 'R2')

# the lookup dbset of profiles used to specify connections 
Db = namedtuple('Db', 'dbname boxname')
_Dbs = (Db('RDxETL', 'USHPEPVSQL409'), Db('RDxReport', 'USHPEPVSQL409'))   

ENVS = ('dev',)

DBSET = DbSet(DbProfile.get_profiles(envs=ENVS, apps=APPS, dbs=_Dbs))

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

def get_work_path(path, old_dir=None, new_dir=None):
    if not old_dir:
        old_dir = REMOTE_DIR
    if not new_dir:
        new_dir = ConfigMgr.WORK_DIR
    
    return re.sub(old_dir, new_dir, path)                             


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
                if env!=None: env=env.upper()
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
            print
            cm = ConfigMgr(dbset=DBSET, path=path)
            ms = cm.go(env='dev')    
            print 'Match check:'
            for filename in ms.matches.keys() :
                print 'In file', filename
                for cmi in ms.matches[filename]:
                    print '  line {}, {} is pointed to {} ({})'.format(
                        cmi.linenum, cmi.matchProf.dbname, cmi.matchProf.boxname, cmi.matchProf.env)
            
       
            #print os.linesep.join(config_files) 
            sourcepaths = [k for k, v in ms.matches.iteritems() if len(v) > 0]
            targpaths = [get_work_path(k) for k, v in ms.matches.iteritems() if len(v) > 0]    
 
            print
            print ms.match_dict_summary()
            print
            FileUtils.copy_files(sourcepaths, targpaths, do_ask)
            print len(sourcepaths), 'file(s) copied to work directory', ConfigMgr.WORK_DIR
            
        if do_mod:        
            print
            print 'Performing file mod...'    
            ms = ConfigMgr(dbset=DBSET, path=ConfigMgr.WORK_DIR).go(env='dev', write=True)     
            print
            print 'Results:'
            for filename in ms.matches.keys() :
                print 'FILE:', filename
                for cmi in ms.matches[filename]:
                    print '  line {}, {} is pointed to {}'.format(cmi.linenum, cmi.matchProf.dbname, cmi.matchProf.boxname), 
                    if cmi.suggProf:
                        print '... changing to {}'.format(cmi.suggProf.boxname)
                    else:
                        print '... No suggested change.'
            
            print
            print ms.match_dict_summary()
            print
            print 'New files written: '
            print os.linesep.join(f for f in ms.get_new_filenames())
        
            
        
        
        
        
        
        print 'Quick Search, Path:', path
        print '{0:3} .config files in path.'.format(len(FileUtils.get_filelist(path))) 

        # a quick raw search, for a double check
        s = FileUtils.search_files(path, 'Data Source=(.+);Initial Catalog=(RDx\w+);')
        
        print '{0:3} files with matches.'.format(len([k for k,v in s.iteritems() if len(v)]))
        #print os.linesep.join(['{0:60} {1}'.format(k, len(v)) for k,v in s.iteritems() if len(v)])
  
        print '{0:3} files with NO matches.'.format(len([k for k,v in s.iteritems() if len(v) == 0]))
        print os.linesep.join(['  ' + str(k) for k,v in s.iteritems() if not len(v)])
                
        print
        print "Complete."
    except Usage, err:
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:", err.msg
        return 2

        
if __name__ == "__main__":
    sys.exit(main())        