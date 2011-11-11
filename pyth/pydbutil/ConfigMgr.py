#! /usr/bin/python
"""Handles database connection strings in files using DbProfiles.

Usage: 
Init the class with -dbsetfile and -path and call the public functions:
    check()      - to look for conn strings in any file via regex. No changes.
    handle_xml() - look for conn strings in config file via xml parse. The Write
                   option will write new file in output directory.

>>> cm = ConfigMgr(dbsource='input/DbSet.data.csv', path='input/test.config')
>>> cm.handle_xml(write=False, env='prod')
File: /Users/hills/git-hill/pyth/pydbutil/input/test.config
Conn change: RDxETL connection from Usfshwssql094 to usfshwssql077
Conn change: RDxETL connection from Usfshwssql094 to usfshwssql077
Conn change: RDxETL connection from Usfshwssql094 to usfshwssql077
Conn change: RDxReport connection from Usfshwssql089 to usfshwssql084
<BLANKLINE>
4 matches in file input/test.config
<BLANKLINE>

The rest of the usage tests are in 'test_ConfigMgr.txt'
To call the tests:,
   ./ConfigMgr.py -v 

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

class ConfigMgr(object):
    """Handles database connection strings in files using DbProfiles.
    
    More usage tests are in 'test_ConfigMgr.txt'
    Run ./ConfigMgr.py -v
    """

    def __init__(self, dbsource=None, path=None, env='dev', write=False, verbose=False):
        self.dbset = DbSet(cvsfile=dbsource)
        self.path = path
        self.env = env
        self.write = write
        self.verbose = verbose
        #self.filelist = ConfigMgr.get_filelist(path)

    def set_path(self, value):
        self.filelist = ConfigMgr.get_filelist(value)
        self._path = value

    def get_path(self):
        return self._path

    path = property(get_path, set_path)

    @staticmethod
    def get_filelist(path):
        """Gets filelist for dir or file path """
        filelist = []
        if path:
            if os.path.isfile(path) :
                filelist = [path]
            elif os.path.isdir(path) :
                #iterate files in specified dir that match *.config
                for config_file in glob.glob(os.path.join(path,  "*.config")) :
                    filelist.append(config_file)
        #print 'Got filelist {}'.format(filelist)
        return filelist

    @staticmethod
    def trim_line(self, longline, max_length=80, chars_trimmed=20, chars_shown=65):
        """Returns a block from the middle of the line, with ellipsis."""
        shortline = longline.strip()
        if len(shortline) > chars_shown and len(shortline) > chars_trimmed :
            shortline = '...' + shortline[chars_trimmed : chars_trimmed+chars_shown] + '...'
        return shortline

    @staticmethod
    def get_config_files(app='MP', path='input/'):
        """Gets config files for app name in given path. 
        Matches files with {app}*.exe in the file for the given path.

        Usage:  
        >>> print ConfigMgr.get_config_files()
        ['input/UMG.RDx.ETL.MP.exe.config', 'input/UMG.RDx.ETL.MP.vshost.exe.config']
        """
        config_files = []
        for filename in glob.glob(os.path.join(path,  "*.config")) :
            if re.search(app + '.+exe', filename): 
                config_files.append(filename)
        return config_files
            


    def get_conn_matches(self):
        """Get conn string matches by line for self.filelist.
        Returns:
        Dict of match data and line num, keyed by filename.
        Usage:
        Set path to one file, check.
        >>> cm = ConfigMgr(dbsource='input/DbSet.data.csv', path='input/UMG.RDx.ETL.R2.vshost.exe.config')
        >>> match_dict = cm.get_conn_matches()
        >>> print match_dict
        {'input/UMG.RDx.ETL.R2.vshost.exe.config': [('usfshwssql104', 'RDxETL', 8), ('usfshwssql104', 'RDxETL', 13), ('usfshwssql104', 'RDxETL', 17), ('usfshwssql104', 'RDxReport', 21)]}
        >>> print ['{} matches in file {}'.format(len(match_dict[filename]), filename) for filename in match_dict.keys()]
        ['4 matches in file input/UMG.RDx.ETL.R2.vshost.exe.config']
        """

        tot_match_count = 0
        match_msg = ''
        
        # filename:matchlist
        match_dict = {}

        for filename in self.filelist:

            # read all lines of file into var
            with open(filename, 'r') as file:
                lines = file.readlines()

            file_match_info = []
            linenum = 0

            # check lines
            for line in lines:
                linenum = linenum +1
                # regex='Data Source=(Usfshwssql\w+);Initial Catalog=(RDx\w+);'
                # print 'line {}:{}    {}'.format(str(linenum), os.linesep, self.trim_line(line))
                m = re.search(self.dbset.regex, line, re.IGNORECASE)
                if m:
                    file_match_info.append((m.group(1).lower(), m.group(2), linenum))
            match_dict[filename] = file_match_info

        return match_dict


    def conn_matches_report(self):
        """ Prints output report for data generated by get_conn_matches().
        
        Usage:
        Set path to one file, check.
        >>> cm = ConfigMgr(dbsource='input/DbSet.data.csv', path='input/UMG.RDx.ETL.R2.vshost.exe.config')
        >>> cm.conn_matches_report()
        In file input/UMG.RDx.ETL.R2.vshost.exe.config:
          ('usfshwssql104', 'RDxETL', 8) matched MP RDxETL dev usfshwssql104 from the dataset.
          ('usfshwssql104', 'RDxETL', 13) matched MP RDxETL dev usfshwssql104 from the dataset.
          ('usfshwssql104', 'RDxETL', 17) matched MP RDxETL dev usfshwssql104 from the dataset.
          ('usfshwssql104', 'RDxReport', 21) matched None from the dataset.
            **Likely profile from dataset is 'MP RDxReport uat usfshwssql089'
        """

        match_dict = self.get_conn_matches()
        
        for filename in match_dict.keys():
            print 'In file {}:'.format(filename)
            for m in match_dict[filename]:
                m_boxname, m_dbname = m[0], m[1]
                dbset_match = self.dbset.get_profile_by_attribs(dict(boxname=m_boxname, dbname=m_dbname))
                print '  {} matched {} from the dataset.'.format(m, dbset_match)
                if not dbset_match:
                    print "    **Likely profile from dataset is '{}'".format(
                        self.dbset.get_profile_by_attribs(dict(dbname=m_dbname)))


    def change_conn(self, old_conn, new_env='DEV'):
        """Change db connection strings via re.
        Usage:
        """   
        
        if (not self.dbset) or (len(self.dbset) is 0) :
            raise Usage('Cannot change_con because dbset is empty or invalid.')
             
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
        Tests for this are function are in in 'test_ConfigMgr.txt'
        Run ./ConfigMgr.py -v         
        """

        if env:
            self.env = env
        
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

            if self.write:
                newfilename = self.get_output_filename(xmlfilename)
                tree.write(newfilename)
                print 'Wrote', newfilename

        print
        print match_msg
        if len(self.filelist) > 1:
            print str(tot_match_count) + ' TOTAL changes.'



if __name__ == "__main__":
    import doctest
    doctest.testfile("tests/test_ConfigMgr.txt")
    doctest.testmod(verbose=True)
    sys.exit(0)
    #sys.exit(main())



