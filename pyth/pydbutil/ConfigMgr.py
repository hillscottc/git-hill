#! /usr/bin/python

import sys
import getopt
import shutil
import re 
import os
import glob
from DbProfile import DbProfile
from DbSet import DbSet
from xml.etree.ElementTree import ElementTree, parse, tostring

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

class ConfigMgr():
    """Handles database connection strings in files using DbProfiles.
    
    Init with a dataset.
    >>> cm = ConfigMgr(cvsfile='input/DbSet.data.csv')
    Loaded 6 profile(s).


    
    
    #File : /Users/hills/git-hill/pyth/pydbutil/input/test.config
    #   line 69 : 
    #      ...onnectionString="Data Source=Usfshwssql094;Initial Catalog=RDxETL...
    #     *MATCH* with a db in the db set.
    #   line 74 : 
    #      ...ta Source=Usfshwssql094;Initial Catalog=RDxETL;Integrated Securit...
    #     *MATCH* with a db in the db set.
    #   line 78 : 
    #      ...ta Source=Usfshwssql094;Initial Catalog=RDxETL;Integrated Securit...
    #     *MATCH* with a db in the db set.
    #   line 82 : 
    #      ...ta Source=Usfshwssql089;Initial Catalog=RDxReport;Integrated Secu...
    #     *MATCH* with a db in the db set.
    # <BLANKLINE>
    # 4 matches in file input/test.config
    # <BLANKLINE>
    
    # Check a directory, all files matching *.config.
    # 
    # >>> cm.path = 'input/'
    # Loading file input/DbSet.data.csv
    # Loaded DbSet with 6 profiles.
    # File : /Users/hills/git-hill/pyth/pydbutil/input/test.config
    # <BLANKLINE>
    # File : /Users/hills/git-hill/pyth/pydbutil/input/test2.config
    # <BLANKLINE>
    # 4 matches in file input/test.config
    # 4 matches in file input/test2.config
    # <BLANKLINE>
    # 8 TOTAL matches.



    Usage: 
        ./ConfigMgr.py -d input/DbSet.data.csv -p input/test.config
        ./ConfigMgr.py -d input/DbSet.data.csv -p input/
        ./ConfigMgr.py -d input/DbSet.data.csv -p input/ -e prod
        ./ConfigMgr.py -d input/DbSet.data.csv -p input/test.config -e dev -w
        ./ConfigMgr.py -d input/DbSet.data.csv -p input/ -e prod -w
    Args:
        -t: test (No other input. Runs the doc tests.)
        -d: dbsetfile (cvs file)     REQUIRED
        -p: path (input file or dir) REQUIRED
        -e: the env to switch to {env, uat, or prod}    
        -w: writes output file

    """

    def __init__(self, cvsfile, path=None, env=None, write=False):
        self.dbset = DbSet(cvsfile=cvsfile)
        if path: self.set_path(path)
        if env: self.set_env(env)
        
        # if not write :
        #     self.check(*self.filelist) 
        # else: 
        #     if env is None: raise Usage('')    

    def set_path(self, path):
        """Sets filelist to path, file or dir.
        
        Set path to one file.
        >>> cm = ConfigMgr(cvsfile='input/DbSet.data.csv').set_path('input/test.config')
        Loaded 6 profile(s).
        Set filelist to ['input/test.config']
        
        Set path to a dir.
        >>> cm = ConfigMgr(cvsfile='input/DbSet.data.csv').set_path('input/')
        Loaded 6 profile(s).
        Set filelist to ['input/test.config', 'input/test2.config']
        """             
        self.filelist = []
        if path:
            if os.path.isfile(path) :
                self.filelist = [path]
            elif os.path.isdir(path) :
                #iterate files in specified dir that match *.config        
                for config_file in glob.glob(os.path.join(path,  "*.config")) :
                    self.filelist.append(config_file)
        print 'Set filelist to {}'.format(self.filelist)
        
    
    def set_env(self, env):
        self.env = env
        if env:
            self.handle_xml(env)
            

    def trim_line(self, longline, max_length=80, chars_trimmed=20, chars_shown=65):
        """Returns a block from the middle of the line, with ellipsis."""
        shortline = longline.strip()
        if len(shortline) > chars_shown and len(shortline) > chars_trimmed :
            shortline = '...' + shortline[chars_trimmed : chars_trimmed+chars_shown] + '...'
        return shortline

    def check(self, *filelist):
        """Checks and reports db connection strings. Any kind of text file.
        
        Set path to one file, check.
        >>> cm = ConfigMgr(cvsfile='input/DbSet.data.csv', path='input/test.config')
        Loaded 6 profile(s).
        Set filelist to ['input/test.config']
        >>> cm.check()
        File : /Users/hills/git-hill/pyth/pydbutil/input/test.config
          line 69 : 
             ...onnectionString="Data Source=Usfshwssql094;Initial Catalog=RDxETL...
            *MATCH* with a db in the db set.
          line 74 : 
             ...ta Source=Usfshwssql094;Initial Catalog=RDxETL;Integrated Securit...
            *MATCH* with a db in the db set.
          line 78 : 
             ...ta Source=Usfshwssql094;Initial Catalog=RDxETL;Integrated Securit...
            *MATCH* with a db in the db set.
          line 82 : 
             ...ta Source=Usfshwssql089;Initial Catalog=RDxReport;Integrated Secu...
            *MATCH* with a db in the db set.
        <BLANKLINE>
        4 matches in file input/test.config
        <BLANKLINE>


        """
        
        # if none is explicitly passed, use the self list.
        if len(filelist) is 0:
            filelist = self.filelist
            
        tot_match_count = 0
        match_msg = ''
    
        for filename in filelist:

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
                    # don't print all these messages if its a whole dir
                    if len(filelist) == 1 :
                        print '  line', str(linenum), ':', os.linesep, '    ', self.trim_line(line)
                
                    if self.dbset.has_db_box(m_dbname,m_boxname) :
                        matchcount = matchcount + 1
                        if len(filelist) == 1 :
                            print '    *MATCH* with a db in the db set.'
                                          
            tot_match_count = tot_match_count + matchcount
            match_msg = match_msg + str(matchcount) + ' matches in file ' + filename + os.linesep
            print ''
        
        print match_msg
        if len(filelist) > 1 : print str(tot_match_count) + ' TOTAL matches.'


    def change_conn(self, old_conn,new_env='DEV'):
        """Change db connection strings via re."""
        new_conn = old_conn # default to orig val if no match 
    
        m = re.search(self.dbset.regex, old_conn)
        if m:
            boxname, dbname = m.group(1), m.group(2)
            #new_boxname = DbProfile.DB[(dbname, new_env)].boxname
            new_boxname = self.dbset.get_profile(dbname, new_env).boxname
            print 'Conn change:', dbname, 'connection from', boxname, 'to', new_boxname
            new_conn = re.sub(boxname, new_boxname, old_conn) 
        return new_conn


    def get_output_filename(self, filename, outdir="output"):
        """ Returns abs path to ./outdir/filename """
        path = os.path.abspath(filename)
        head, tail = os.path.split(path)
        return os.path.join(os.getcwd(), outdir, tail)


    def handle_xml(self, env=None, write=False, *xml_file_list):
        """Find and change connectionStrings node of xmlfile."""
        
        # if none is explicitly passed, use the self.
        if env is None:
            env = self.env        
        if len(xml_file_list)  is 0:
            xml_file_list = self.filelist
        
        tot_match_count = 0
        match_msg = ''    
        for xmlfilename in xml_file_list:   
    
            print "File:", os.path.abspath(xmlfilename)
            matchcount = 0
            tree = ElementTree()
            root = tree.parse(xmlfilename)
            for con_str_node in root.findall('connectionStrings'):
                for add_node in con_str_node.findall('add'):
                    old_conn = add_node.attrib['connectionString']
                    # change the con node here
                    add_node.attrib['connectionString'] = self.change_conn(old_conn, env)
                    matchcount = matchcount + 1
                tot_match_count = tot_match_count + matchcount
                match_msg = match_msg + str(matchcount) + ' matches in file ' + xmlfilename + os.linesep
                print
                
            if write:
                newfilename = self.get_output_filename(xmlfilename)
                tree.write(newfilename)
                print 'Wrote', newfilename

        print
        print match_msg
        if len(xml_file_list) > 1:
            print str(tot_match_count) + ' TOTAL changes.'   

def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(
                argv[1:], "hd:p:e:wt", ["help", "dbsetfile=", "path=",
                                        "env=", "write", "test"])
        except getopt.error, msg:
            raise Usage(msg)

        dbsetfile = None
        path = None
        env = None
        write = False

        for opt, arg in opts :
            if opt in ("-h", "--help"):
                print __doc__
                sys.exit(0)
            elif opt in ("-t", "--test"):
                import doctest
                doctest.testmod(verbose=True)
                sys.exit(0)                
            elif opt in ("-d", "--dbsetfile"):
                dbsetfile = arg
            elif opt in ("-p", "--path"):
                path = arg               
            elif opt in ("-e", "--env"):
                env = arg
                if env!=None: env=env.upper()       
            elif opt in ("-w", "--write"):
                write = True   


        if (not dbsetfile) or (not os.path.isfile(dbsetfile)):
            raise Usage("Invalid dbsetfile '{}'".format(dbsetfile))

        cm = ConfigMgr(cvsfile=dbsetfile)

        filelist = []
        if os.path.isfile(path) :
            filelist = [path]
        elif os.path.isdir(path) :
            #iterate files in specified dir that match *.config        
            for config_file in glob.glob(os.path.join(path,  "*.config")) :
                filelist.append(config_file) 
        else :
            raise Usage("Invalid path '{}'".format(path))

        if not write :
            cm.check(*filelist) 
            sys.exit(0)  
        else:
            if env is None:
                raise Usage('') 

        cm.handle_xml(env, write, *filelist)

        print "Complete."
        print

    except Usage, err:
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:",err.msg
        return 2

if __name__ == "__main__":
    sys.exit(main())