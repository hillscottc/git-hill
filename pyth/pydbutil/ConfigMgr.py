#! /usr/bin/python
"""Handles database connection strings in files using DbProfiles.

Usage: go() is the main function. Many examples in tests below.
>>> from MatchSet import MatchSet
>>> ms = ConfigMgr(dbsource='input/DbSet.data.csv', path='input/ETL/MP/UMG.RDx.ETL.MP.vshost.exe.config').go(verbose=False)
  4 matches in 1 files.
"""
import sys
import re
from ConnMatchInfo import ConnMatchInfo
from MatchSet import MatchSet
from DbProfile import DbProfile
import FileUtils




class ConfigMgr(object):
    """Handles database connection strings in files using DbProfiles.
    """
    
    WORK_DIR = 'work'
    OUTPUT_DIR = 'output'
    
    REGEX = 'Data Source=(.+);Initial Catalog=(RDx\w+);'
    
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


    
    def go(self, filelist=None, app=None, env=None, write=False, verbose=True) :
        """Checks file for lines which contain connection string information,
        for each file in filelist.
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
                app_for_file = apps_for_file[0]
                  

            if write: 
                outfilename = FileUtils.get_output_filename(ConfigMgr.WORK_DIR,
                                                            ConfigMgr.OUTPUT_DIR,
                                                            filename)
            
            #match_msgs.append('In file {}:'.format(filename))

            # read all lines of file into var
            with open(filename, 'r') as infile:
                lines = infile.readlines()

            cmiList = []
            linenum = 0
            outlines = ''

            # check lines
            for line in lines:
                linenum = linenum +1
                
                # Does this line look like a db?
                m = re.search(self.REGEX, line, re.IGNORECASE)
                if m:
                    m_boxname, m_dbname = m.group(1), m.group(2)
        
                    #cmi = ConnMatchInfo(m_boxname, m_dbname, linenum)
                    matched_profile = DbProfile(boxname=m_boxname, dbname=m_dbname,
                                                env=env, app=app_for_file)
                    
                    outfilename = FileUtils.get_output_filename(ConfigMgr.WORK_DIR, ConfigMgr.OUTPUT_DIR, filename)
                    
                    cmi = ConnMatchInfo(matched_profile, linenum, newFilename=outfilename)
                    
                    sugg_profs = self.dbset.get(cmi.matchProf)
                    if len(sugg_profs):
                        # we have a perfect match already.
                        cmi.suggProf = sugg_profs[0]
                    

                    # if no (exact match) sug yet, get the correect prof for this app+dbname+env
                    if not cmi.suggProf:
                                                                                    
                        suggestions = self.dbset.get_by_atts(dict(dbname=cmi.matchProf.dbname, app=app_for_file, env=env))
                        
                        if len(suggestions):
                            cmi.suggProf = suggestions[0]
                            if write:
                                line = re.sub(m_boxname, cmi.suggProf.boxname, line, re.IGNORECASE)
                                #match_msgs.append('    * Connection on line {} changing from {} to {}'.format(linenum, m_boxname, cmi.suggProf.boxname))     
                    
                    cmiList.append(cmi)
                            
                if write:
                    outlines = outlines + line

            ms.matches[filename] = sorted(cmiList, key = lambda x: x.linenum)

            if write:
                outfilename = FileUtils.get_output_filename(ConfigMgr.WORK_DIR, ConfigMgr.OUTPUT_DIR, filename)
                with open(outfilename, 'w') as outfile:
                    outfile.write(outlines)
                #match_msgs.append('Wrote file ' + outfilename)
        
        return ms
    

        

if __name__ == "__main__":
    import doctest
    #doctest.testmod(verbose=True)
    doctest.testfile("tests/test_ConfigMgr.txt", verbose=True)
    sys.exit(0)
   


