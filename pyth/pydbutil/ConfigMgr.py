#! /usr/bin/python
"""Handles database connection strings in an xml file

Usage: 
    ./ConfigMgr.py -p test.config   (1 file)
    ./ConfigMgr.py -p /config_dir     (all files named .config in the dir)
    ./ConfigMgr.py -p test.config  -e prod
    ./ConfigMgr.py -p /config_dir   -e dev -w
Args:
    -d: database profile (cvs file)
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
import DbProfile
from xml.etree.ElementTree import ElementTree, parse, tostring

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

# FIX THIS
# this will be a default var called output DIR soon
OUTDIR = "_output"
CONFIG_FILE_EXT = '*.config'


class ConfigMgr():
    """ Handles database connection strings"""

    def __init__(self, cvsfile):
        self.dbset = DbProfile.DbSet(cvsfile=cvsfile)

    def trim_line(self, longline, max_length=80, chars_trimmed=20, chars_shown=65):
        """Returns a block from the middle of the line, with ellipsis."""
        shortline = longline.strip()
        if len(shortline) > chars_shown and len(shortline) > chars_trimmed :
            shortline = '...' + shortline[chars_trimmed : chars_trimmed+chars_shown] + '...'
        return shortline

    def is_process_file(self, filename) :
        """CHANGE THIS!!!! Should check if par dir, maybe"""    
        #if re.search(NEW_FILE_TAG, os.path.abspath(filename)) : return True
        #else : return False
        return False

    def check(self, *filelist):
        """Checks and reports db connection strings. Any kind of text file."""
        tot_match_count = 0
        match_msg = ''
    
        for filename in filelist:
        
            if self.is_process_file(filename) :
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
                m = re.search(self.dbset.regex, line)
                if m:
                    m_boxname, m_dbname = m.group(1).lower(), m.group(2)
                    print '  line', str(linenum), ':', os.linesep, '    ', self.trim_line(line)
                
                    if self.dbset.has_db_box(m_dbname,m_boxname) :
                        print '    *MATCH* with a db in the db set.'
                        matchcount = matchcount + 1
                                          
            tot_match_count = tot_match_count + matchcount
            match_msg = match_msg + str(matchcount) + ' matches in file ' + filename + os.linesep
            print ''
        
        print match_msg
        if len(filelist) > 1 : print str(tot_match_count) + ' TOTAL matches.'


    def change_conn(self, old_conn,new_env='DEV'):
        """Change db connection strings via re."""
        new_conn = old_conn # default to orig val if no match 
    
        m = re.search(REGEX, old_conn)
        if m:
            boxname, dbname = m.group(1), m.group(2)
            #new_boxname = DbProfile.DB[(dbname, new_env)].boxname
            new_boxname = self.dbset.get_profile(dbname, new_env).boxname
            print 'Conn change:', dbname, 'connection from', boxname, 'to', new_boxname
            new_conn = re.sub(boxname, new_boxname, old_conn) 
        return new_conn


    def get_new_filename(self, filename, tag="_new_"):
        """ Given filename config.txt, returns config<tag>.txt"""
        path = os.path.abspath(filename)
        head, tail = os.path.split(path)
        root, ext = os.path.splitext(tail)
        return root + tag + ext


    def move_files(self, old_filename, new_filename, bak_dir='bak') :
        """ Write new files and backups """
        head, tail = os.path.split(old_filename)
        bak_filename = os.path.join(head, 'bak', tail )
    
        print 'try Moving', old_filename, 'to', bak_filename
        #shutil.move(old_filename, bak_filename)
    
        print 'try Moving', new_filename, 'to', old_filename
        #shutil.move(new_filename, old_filename)    
    

    def handle_xml(self, env, write=False, outdir=OUTDIR, *xml_file_list):
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
                sys.exit(0)
            
                #match_msg = match_msg + '  New file would be ' +  get_new_filename(xmlfilename) + os.linesep
                new_filename = get_new_filename(xmlfilename)
                #match_msg = match_msg + '  Writing new file ' +  new_filename + os.linesep
                tree.write(new_filename)
                move_files(os.path.abspath(xmlfilename), os.path.abspath(new_filename))
            
            
        print
        print match_msg
        if len(xml_file_list) > 1:
            print str(tot_match_count) + ' TOTAL changes.'   

