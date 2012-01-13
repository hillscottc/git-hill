#! /usr/bin/python
"""Handles database connection strings in files using DbProfiles.

Usage: go() is the main function. Many examples in tests below.
>>> from MatchSet import MatchSet
>>> ms = ConfigMgr(dbsource='input/DbSet.data.csv', path='input/ETL/MP/UMG.RDx.ETL.MP.vshost.exe.config').go(verbose=False)
  4 matches in 1 files.
"""
import sys
import re
import os
from MatchFtp import MatchFtp
from MatchConn import MatchConn
from MatchLog import MatchLog
from MatchSet import MatchSet
from DbProfile import DbProfile
from collections import namedtuple
import FileUtils


class ConfigMgr(object):
    """Handles database connection strings in files using DbProfiles."""
    
    WORK_DIR = os.path.join(os.getcwd(), 'work')
    OUTPUT_DIR = os.path.join(os.getcwd(), 'output')
    
    FTP_ROOT = 'USHPEWVAPP251'
    LOG_PATH = r'D:\RDx\ETL\logs'
        
    re_type = namedtuple('re_type', 't regex')
    RE_TYPES = (re_type('LOG_A', '<file value="(.+)"'),
                re_type('LOG_B', '"file" value="(.+)"'),
                re_type('DB', 'Data Source=(.+);Initial Catalog=(RDx\w+);'),
                re_type('FTP', r'"(.+)" value="\\\\(.+)\\d\$'))
    
    
    def __init__(self, dbset=None, path=None, env=None, write=False, verbose=True):
        self.dbset = dbset
        self.path = path
        self.env = env
        self.write = write
        self.verbose = verbose
        self.WORK_DIR = FileUtils.ensure_dir(self.WORK_DIR)
        self.OUTPUT_DIR = FileUtils.ensure_dir(self.OUTPUT_DIR)
        
    def set_path(self, value):
        if not self.dbset: raise Exception('dbset is required when setting path.')
        self.filelist = FileUtils.get_filelist(value)
        #print 'Set path to ' + value
        self._path = value

    def get_path(self):
        return self._path

    path = property(get_path, set_path)


    def get_logname(self, app):
        #logpath = os.path.join(self.LOG_PATH, app)
        logpath = self.LOG_PATH + "\\" + app
        return logpath + "\\" + app + '_etl.txt'


    def parse_line_db(self, re_match, line, linenum, env, app):
        """Returns: cmi """
        # get db data from re_match
        matched_profile = DbProfile(
                           boxname=re_match.group(1).upper(),
                           dbname=re_match.group(2), 
                           env=env, app=app)
        
        cmi = MatchConn(matched_profile, linenum)
    
        sugg_profs = self.dbset.get(cmi.before)     
        
        if len(sugg_profs):
            # we have a perfect match already.
            cmi.after = sugg_profs[0]       
        
        # if no (exact match) sug yet, get the correect prof for this app+dbname+env
        if not cmi.after:
            #print '####', cmi.before, 'was  not', cmi.after                                                        
            suggestions = self.dbset.get_by_atts(
                           dict(dbname=cmi.before.dbname,
                                app=app, env=env))
            
            if len(suggestions):
                cmi.after = suggestions[0]
            
        return cmi

    def go(self, filelist=None, app=None, env=None, write=False, verbose=True) :
        """Checks file for lines which contain connection string information,
        for each file in filelist.
        Returns: a MatchSet
        """
        
        if not filelist:
            filelist = self.filelist
        if not filelist:
            raise Exception('filelist required.')
        
        if write:
            if not env :
                raise Exception('env is required for write.')

        if app:
            apps = [app]
        else:
            apps = self.dbset.get_apps()
            
        ms = MatchSet()
        
        for filename in filelist:
                        
            # the name of this file matches which of the apps?
            apps_for_file = [app for app in apps if re.search(app, filename, re.IGNORECASE)]
            
            # skip this file, if its none
            if not len(apps_for_file) :
                print '**************************Skipping file', filename
                continue
            else:
                app = apps_for_file[0]
                  

            # read all lines of file into var
            with open(filename, 'r') as infile:
                lines = infile.readlines()

            maList = []
            linenum = 0
            outlines = ''
            
            # check lines
            for line in lines:
                linenum = linenum +1
                
                m = None
                m_type = None                
                
                # which of the RE_TYPES does this line match?
                for re_type in self.RE_TYPES:
                    m = re.search(re_type.regex, line, re.IGNORECASE) 
                    if m:
                        m_type = re_type.t
                        break
                
                
                if m_type is 'LOG_A' or m_type is 'LOG_B':
                    
                    matchLog = MatchLog(before=m.group(1), linenum=linenum,
                                        after=self.get_logname(app))
                    
                    maList.append(matchLog)
                    try:     
                        if write:
                            line = re.sub(re.escape(matchLog.before),
                                          matchLog.after, line, re.IGNORECASE)
                    except:
                        print '*** File {} , line {} not updated.'.format(
                                               filename, line)
                        print '*** Failed to change {} to {}'.format(
                                               matchLog.before, matchLog.after)   
                                     
                elif m_type is 'FTP':
                                        
                    matchFtp = MatchFtp(before=m.group(2),
                                        linenum=linenum,
                                        after=self.FTP_ROOT,
                                        ftpname=m.group(1))
                    
                    maList.append(matchFtp)       
                    if write:                        
                        line = re.sub(matchFtp.before, matchFtp.after,
                                      line, re.IGNORECASE)                       
                
                elif m_type is 'DB':
                    matchConn = self.parse_line_db(m, line, linenum, env, app)
                    
                    maList.append(matchConn)
                            
                    if write :
                        line = re.sub(re.escape(m.group(1)),
                                      matchConn.after.boxname, line, re.IGNORECASE)  
                
                
                outlines = outlines + line

            ms.matches[filename] = sorted(maList, key = lambda x: x.linenum)

            if write:
                outfilename = FileUtils.get_output_filename(
                               ConfigMgr.WORK_DIR, ConfigMgr.OUTPUT_DIR, filename)
                with open(outfilename, 'w') as outfile:
                    #str_lines = [re.sub('\r', '\r\n', line for line in outlines]
                    outfile.write(outlines)
                
        
        return ms
    

if __name__ == "__main__":
    import doctest
    #doctest.testmod(verbose=True)
    doctest.testfile("tests/test_ConfigMgr.txt", verbose=True)
    sys.exit(0)
   


