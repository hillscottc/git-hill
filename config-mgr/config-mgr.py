#! /usr/bin/python
"""Checks the database connection strings in an xml file against data in *required* DbProfile.py.

Usage: 
    ./config-mgr.py -p myfile.config   (1 file)
    ./config-mgr -p /config_dir     (all files named .config in the dir)
    ./config-mgr -p myfile.config  -e prod
    ./config-mgr -p /config_dir   -e dev -w
Args:
    -p: targ file or dir
    -e: the env to switch to {env, uat, or prod}    
    -w: writes output file 
Returns:
Raises:
"""

import sys
import getopt
import shutil
import re 
import os
import glob
from .. import pydbutil
from xml.etree.ElementTree import ElementTree, parse, tostring

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

REGEX = re.compile('Data Source=(Usfshwssql\w+);Initial Catalog=(RDx\w+);', re.I)
NEW_FILE_TAG = "_new_"
CONFIG_FILE_EXT = '*.config'

def trim_line(longline, max_length=80, chars_trimmed=20, chars_shown=65):
    """Returns a block from the middle of the line, with ellipsis."""
    shortline = longline.strip()
    if len(shortline) > chars_shown and len(shortline) > chars_trimmed :
        shortline = '...' + shortline[chars_trimmed : chars_trimmed+chars_shown] + '...'
    return shortline


def is_process_file(filename) :
    """A process file is one written by this script, like _new_. Should be skipped."""    
    if re.search(NEW_FILE_TAG, os.path.abspath(filename)) :
        return True
    else :
        return False


def check(*filelist):
    """Checks and reports db connection strings. Any kind of text file."""
    tot_match_count = 0
    match_msg = ''
    
    for filename in filelist:
        
        if is_process_file(filename) :
            print "File SKIPPED : " + os.path.abspath(filename)
            continue        
            
        # read all lines of file into var    
        with open(filename, 'r') as file:
            lines = file.readlines()
                
        print "File :", os.path.abspath(filename)

        linenum = 0
        matchcount = 0

        # check lines
        for line in lines:
            linenum = linenum +1
            m = re.search(REGEX, line)
            if m:
                m_boxname, m_dbname = m.group(1).lower(), m.group(2)
                print '  line', str(linenum), ':', os.linesep, '    ', trim_line(line)
                for dbkey, db in DbProfile.DB.items() :
                   if db.boxname==m_boxname and db.dbname==m_dbname :
                        print '    *MATCH*', db.get_key()
                        matchcount = matchcount + 1             
        tot_match_count = tot_match_count + matchcount
        match_msg = match_msg + str(matchcount) + ' matches in file ' + filename + os.linesep
        print ''
        
    print match_msg
    if len(filelist) > 1 : print str(tot_match_count) + ' TOTAL matches.'


def change_conn(old_conn,new_env='DEV'):
    """Change db connection strings via re."""
    new_conn = old_conn # default to orig val if no match 
    
    m = re.search(REGEX, old_conn)
    if m:
        boxname, dbname = m.group(1), m.group(2)
        new_boxname = DbProfile.DB[(dbname, new_env)].boxname
        print 'Conn change:', dbname, 'connection from', boxname, 'to', new_boxname
        new_conn = re.sub(boxname, new_boxname, old_conn) 
    return new_conn


def get_new_filename(filename, tag="_new_"):
    """ Given filename config.txt, returns config<tag>.txt"""
    path = os.path.abspath(filename)
    head, tail = os.path.split(path)
    root, ext = os.path.splitext(tail)
    return root + tag + ext


def move_files(old_filename, new_filename, bak_dir='bak') :
    """ Write new files and backups """
    head, tail = os.path.split(old_filename)
    bak_filename = os.path.join(head, 'bak', tail )
    
    print 'try Moving', old_filename, 'to', bak_filename
    #shutil.move(old_filename, bak_filename)
    
    print 'try Moving', new_filename, 'to', old_filename
    #shutil.move(new_filename, old_filename)    
    

def handle_xml(env, write=False, *xml_file_list):
    """Find and change connectionStrings node of xmlfile.""" 
    tot_match_count = 0
    match_msg = ''    
    for xmlfilename in xml_file_list:   
           
        if is_process_file(xmlfilename) :
            print "File SKIPPED : " + os.path.abspath(xmlfilename)
            continue        
            
        print "File:", os.path.abspath(xmlfilename)
        matchcount = 0
        tree = ElementTree()
        root = tree.parse(xmlfilename)
        for con_str_node in root.findall('connectionStrings'):
            for add_node in con_str_node.findall('add'):
                old_conn = add_node.attrib['connectionString']
                # change the con node here
                add_node.attrib['connectionString'] = change_conn(old_conn, env)
                matchcount = matchcount + 1
            tot_match_count = tot_match_count + matchcount
            match_msg = match_msg + str(matchcount) + ' matches in file ' + xmlfilename + os.linesep
            print
            
        if write:
            #match_msg = match_msg + '  New file would be ' +  get_new_filename(xmlfilename) + os.linesep
            new_filename = get_new_filename(xmlfilename)
            #match_msg = match_msg + '  Writing new file ' +  new_filename + os.linesep
            tree.write(new_filename)
            move_files(os.path.abspath(xmlfilename), os.path.abspath(new_filename))
            
            
    print
    print match_msg
    if len(xml_file_list) > 1:
        print str(tot_match_count) + ' TOTAL changes.'   




def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(argv[1:], "hp:d:e:w", ["help", "path=", "env=", "write"])
        except getopt.error, msg:
            raise Usage(msg)
        path = None
        env = None
        write = False
        
        for opt, arg in opts :
            if opt in ("-h", "--help"):
                print __doc__
                sys.exit(0)
            elif opt in ("-p", "--path"):
                path = arg               
            elif opt in ("-e", "--env"):
                env = arg
                if env!=None: env=env.upper()       
            elif opt in ("-w", "--write"):
                write = True                      
        filelist = []
        if os.path.isfile(path) :
            filelist = [path]
        elif os.path.isdir(path) :
            #iterate files in specified dir that match *.config        
            for config_file in glob.glob(os.path.join(path,  CONFIG_FILE_EXT)) :
                filelist.append(config_file) 
        else :
            raise(path +  "isn't a file or a dir?!")
        
        if not write :
            check(*filelist) 
            sys.exit()  
        else:
            if env is None:
                raise Usage('') 
            else:
                if env not in DbProfile.ENVS : raise Usage()
        
        handle_xml(env, write, *filelist)
        print "Complete."
        print
    except Usage, err:
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:",err.msg
        return 2


if __name__ == "__main__":
    sys.exit(main())

