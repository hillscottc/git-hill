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
import FileUtils


class ConfigMgr(object):
    """Handles database connection strings in files using DbProfiles.
    """
    
    WORK_DIR = 'work'
    OUTPUT_DIR = 'output'
    
    # some of these maybe should be in the dbset
    
    REGEX_DB = 'Data Source=(.+);Initial Catalog=(RDx\w+);'
    REGEX_LOG = '<file value="(.+)"'
    LOG_PATH = r'D:\RDx\ETL\logs'
    REGEX_FTP = r'FilePathIn" value="\\\\(.+)\\d\$'
    FTP_ROOT = 'USHPEWVAPP251'
    
    
    def __init__(self, dbset=None, path=None, env=None, write=False, verbose=True):
        self.dbset = dbset
        self.path = path
        self.env = env
        self.write = write
        self.verbose = verbose
        
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
        """Returns: cmi 
        """

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
            apps_for_file = [app for app in apps if re.search(app, filename)]
            
            # skip this file, if its none
            if not len(apps_for_file) :
                print 'Skipping file', filename
                continue
            else:
                app = apps_for_file[0]
                  

            if write: 
                outfilename = FileUtils.get_output_filename(
                          ConfigMgr.WORK_DIR,ConfigMgr.OUTPUT_DIR, filename)
            
            #match_msgs.append('In file {}:'.format(filename))

            # read all lines of file into var
            with open(filename, 'r') as infile:
                lines = infile.readlines()

            maList = []
            linenum = 0
            outlines = ''
            
            # check lines
            for line in lines:
                linenum = linenum +1
                
                
                if re.search('log4net', filename, re.IGNORECASE):
                    re_match = re.search(self.REGEX_LOG, line, re.IGNORECASE)
                    if re_match:
                        
                        matchLog = MatchLog(before=re_match.group(1), linenum=linenum,
                                            after=self.get_logname(app))
                        
                        maList.append(matchLog)
                        try:     
                            if write:
                                line = re.sub(matchLog.before,
                                              matchLog.after, line, re.IGNORECASE)
                        except:
                            print '*** File {} , line {} not updated.'.format(
                                                   filename, line)
                            print '*** Failed to change {} to {}'.format(
                                                   matchLog.before, matchLog.after)
                
                elif re.search(self.REGEX_FTP, line, re.IGNORECASE):
                    re_match = re.search(self.REGEX_FTP, line, re.IGNORECASE)
                    
                    matchFtp = MatchFtp(before=re_match.group(1),
                                        linenum=linenum, after=self.FTP_ROOT)
                    maList.append(matchFtp)       
                    if write:                        
                        line = re.sub(matchFtp.before, matchFtp.after,
                                      line, re.IGNORECASE)                                                
                    
                else:
                    # Does this line look like a db?
                    re_match = re.search(self.REGEX_DB, line, re.IGNORECASE)
                    if re_match:
                        
                        matchConn = self.parse_line_db(re_match,
                                            line, linenum, env, app)
                        
                        maList.append(matchConn)
                                
                        if write:    
                            print 'FROM-------' , re.escape(re_match.group(1))
                            print 'TO-------' , matchConn.after.boxname              
                            line = re.sub(re.escape(re_match.group(1)),
                                          matchConn.after.boxname, line, re.IGNORECASE)  
                            print 'NEWLINE', line
                        
                                        
                outlines = outlines + line

            ms.matches[filename] = sorted(maList, key = lambda x: x.linenum)

            if write:
                outfilename = FileUtils.get_output_filename(
                               ConfigMgr.WORK_DIR, ConfigMgr.OUTPUT_DIR, filename)
                with open(outfilename, 'w') as outfile:
                    outfile.write(outlines)
        
        return ms
    

if __name__ == "__main__":
    import doctest
    #doctest.testmod(verbose=True)
    doctest.testfile("tests/test_ConfigMgr.txt", verbose=True)
    sys.exit(0)
   


