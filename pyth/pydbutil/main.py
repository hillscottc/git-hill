#! /usr/bin/python
"""Usage of the ConFigMgr and related classes. 


"""
import sys
import os
import shutil
import re
from ConfigMgr import ConfigMgr

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg


# No trailing slash for dirs.

REMOTE_DIR = 'remote'
INPUT_DIR = 'input'
OUTPUT_DIR = 'output'
DBSOURCE = os.path.join('input', 'DbSet.data.csv')

# uses md to return list of source-targ for copying, for files with matches
#def remote_to_input(md, back=False, test=False):
#    tups = []
#    for k_file, v_info in md.iteritems():
#        # at least one conmatch in file?
#        if len(v_info) > 1:
#            newfilename = re.sub(REMOTE_DIR, INPUT_DIR, k_file)
#            tups.append((k_file, newfilename))
#    return tups
      

def get_work_path(path):
    return re.sub(REMOTE_DIR, INPUT_DIR, path)                             

def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        print
        print "Checking files in remote path '{}' ...".format(REMOTE_DIR)
        print
        cm = ConfigMgr(dbsource=DBSOURCE, path=REMOTE_DIR)
        md = cm.go(verbose=False)     
        print os.linesep.join([str(k) + ' ' + str(v) for k, v in sorted(md.iteritems())])
        print
        print ConfigMgr.match_dict_summary(md)
        print
        print 'Files with NO matches: '
        print os.linesep.join(ConfigMgr.get_match_files(md, False))     
        print 
                
        print 'So, the copying will be:' 
        
        sourcepaths = [k for k, v in md.iteritems() if len(v) > 1]
        targpaths = [get_work_path(k) for k, v in md.iteritems() if len(v) > 1]
        
        print os.linesep.join(map('FROM {}\nTO   {}'.format, sourcepaths, targpaths))    
#        # Equivalent to above...    
#        print os.linesep.join('FROM {}\nTO   {}'.format(k, get_work_path(k))
#                              for k, v in md.iteritems() if len(v) > 1)          
            
        r = raw_input('Proceed with copy? y/[n] ')
        if not r.lower() == 'y':
            print 'Ok, stopping.'
            sys.exit(0)
        print
        
        map(shutil.copy, sourcepaths, targpaths)
        
        
        print
        print '(OK DO MOD HERE.)'
        print
        
#        print 'Copy the files back to remote:'
#        for tup in remote_to_input(md):
#            print 'FROM {}\nTO   {}'.format(tup[1], tup[0])      
#        print   
#               
#        r = raw_input('Proceed with copy back to remote? y/[n] ')
#        if not r.lower() == 'y':
#            print 'Ok, stopping.'
#            sys.exit(0)
#        print
#        for tup in remote_to_input(md):
#            print 'FROM {}\nTO   {}'.format(tup[1], tup[0])  
#            shutil.copy(tup[1], tup[0])            
            
      
        
        
        print
        print "Complete."

    except Usage, err:
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:",err.msg
        return 2
        
if __name__ == "__main__":
    sys.exit(main())        