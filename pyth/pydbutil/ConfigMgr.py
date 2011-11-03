#! /usr/bin/python
"""Handles database connection strings in files using DbProfiles.

Usage:
Run ./ConfigMgr.py -v  to call the tests in "test_ConfigMgr.txt" 

These need to be tested since i swtiched to the doctest.

Args:
    -v: verbose test (No other input. Runs the doc tests.)
    -d: dbsetfile (cvs file)     REQUIRED
    -p: path (input file or dir) REQUIRED
    -e: the env to switch to {env, uat, or prod}
    -w: writes output file

"""
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
    Usage:
    Run ./ConfigMgr.py -v  to call the tests in 'test_ConfigMgr.txt"'
    """

    def __init__(self, cvsfile, path=None, env=None, write=False):
        self.dbset = DbSet(cvsfile=cvsfile)
        self.path = self.set_path(path)
        self.env = env
        self.write = write

    def set_path(self, path):
        """Sets filelist to path, file or dir.
        """
        self.filelist = []
        if path:
            if os.path.isfile(path) :
                self.filelist = [path]
            elif os.path.isdir(path) :
                #iterate files in specified dir that match *.config
                for config_file in glob.glob(os.path.join(path,  "*.config")) :
                    self.filelist.append(config_file)
        if len(self.filelist) > 0:
            print 'Set filelist to {}'.format(self.filelist)


    def trim_line(self, longline, max_length=80, chars_trimmed=20, chars_shown=65):
        """Returns a block from the middle of the line, with ellipsis."""
        shortline = longline.strip()
        if len(shortline) > chars_shown and len(shortline) > chars_trimmed :
            shortline = '...' + shortline[chars_trimmed : chars_trimmed+chars_shown] + '...'
        return shortline

    def check(self, *filelist):
        """Checks and reports db connection strings. Any kind of text file.
        Usage:
        Run ./ConfigMgr.py -v  to call the tests in 'test_ConfigMgr.txt"'        
        """
        
        if (filelist) and len(filelist) > 0:
            # if one is explicitly passed, set it to self list.
            self.filelist = filelist

        tot_match_count = 0
        match_msg = ''

        for filename in self.filelist:

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
                    if len(self.filelist) == 1 :
                        #print '  line', str(linenum), ':', os.linesep, '    ', self.trim_line(line)
                        print 'line {}:'.format(str(linenum))
                        print '    ', self.trim_line(line)

                    #if self.dbset.has_db_box(m_dbname,m_boxname) :
                    if self.dbset.get_profile_by_attribs(
                                                        dict(dbname=m_dbname,boxname=m_boxname)): 
                        matchcount = matchcount + 1
                        if len(filelist) == 1 :
                            print '    *MATCH* with a db in the db set.'

            tot_match_count = tot_match_count + matchcount
            match_msg = match_msg + str(matchcount) + ' matches in file ' + filename + os.linesep
            print ''

        print match_msg
        if len(self.filelist) > 1 : print str(tot_match_count) + ' TOTAL matches.'


    def change_conn(self, old_conn, new_env='DEV'):
        """Change db connection strings via re."""
        new_conn = old_conn # default to orig val if no match

        m = re.search(self.dbset.regex, old_conn)
        if m:
            boxname, dbname = m.group(1), m.group(2)

            new_boxname = '***BAD BOX NAME***'
            db = self.dbset.get_profile_by_attribs(dict(dbname=dbname,env=new_env))
            if db : 
                new_boxname =  db.boxname
            print 'Conn change: {} connection from {} to {}'.format(
                                             dbname, boxname, new_boxname)
            new_conn = re.sub(boxname, new_boxname, old_conn)

        return new_conn


    def get_output_filename(self, filename, outdir="output"):
        """ Returns abs path to ./outdir/filename """
        path = os.path.abspath(filename)
        head, tail = os.path.split(path)
        return os.path.join(os.getcwd(), outdir, tail)


    def handle_xml(self, env=None, write=None, *xml_file_list):
        """Find and change connectionStrings node of xmlfile.
        Usage:
        Run ./ConfigMgr.py -v  to call the tests in 'test_ConfigMgr.txt"'        
        """

        if env:
            self.env = env
            
        if write is not None:
            self.write = write
            
        if len(xml_file_list) > 0:
            self.filelist = xml_file_list

        tot_match_count = 0
        match_msg = ''
        for xmlfilename in self.filelist:

            print "File:", os.path.abspath(xmlfilename)
            matchcount = 0
            tree = ElementTree()
            root = tree.parse(xmlfilename)
            for con_str_node in root.findall('connectionStrings'):
                for add_node in con_str_node.findall('add'):
                    old_conn = add_node.attrib['connectionString']
                    # change the con node here
                    add_node.attrib['connectionString'] = self.change_conn(old_conn, self.env)
                    matchcount = matchcount + 1
                tot_match_count = tot_match_count + matchcount
                match_msg = match_msg + str(matchcount) + ' matches in file ' + xmlfilename + os.linesep
                print

            if self.write:
                newfilename = self.get_output_filename(xmlfilename)
                tree.write(newfilename)
                print 'Wrote', newfilename

        print
        print match_msg
        if len(self.filelist) > 1:
            print str(tot_match_count) + ' TOTAL changes.'


def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(
                argv[1:], "hd:p:e:wv", ["help", "dbsetfile=", "path=",
                                        "env=", "write", "verbose"])
        except getopt.error, msg:
            raise Usage(msg)

        dbsetfile = None
        path = None
        env = None
        write = False

        for opt, arg in opts :
            if opt in ("-h", "--help"):
                print ConfigMgr.__doc__
                sys.exit(0)
            elif opt in ("-v", "--verbose"):
                import doctest
                #doctest.testmod(verbose=True)
                doctest.testfile("test_ConfigMgr.txt")
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

        cm = ConfigMgr(cvsfile=dbsetfile, write=write)

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