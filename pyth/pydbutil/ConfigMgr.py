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
from DbSet import DbSet
from ConnMatchInfo import ConnMatchInfo
from MatchSet import MatchSet
from DbProfile import DbProfile
import FileUtils



class ConfigMgr(object):
    """Handles database connection strings in files using DbProfiles.
    """
    #REGEX = 'Data Source=(Usfshwssql\w+);Initial Catalog=(RDx\w+);'
    #REGEX = 'Data Source=([\w\\\]+);Initial Catalog=(RDx\w+);'
    REGEX = 'Data Source=(.+);Initial Catalog=(RDx\w+);'
    WORK_DIR = 'work'
    OUTPUT_DIR = 'output'
    
    def __init__(self, dbsource=None, path=None, env=None, write=False, verbose=True):
        if dbsource: self.dbsource = dbsource
        if path: self.path = path
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
    
    
    def set_dbsource(self, value):
        self._dbsource = value
        self.dbset = DbSet(cvsfile=value)

    def get_dbsource(self):
        return self._dbsource

    dbsource = property(get_dbsource, set_dbsource)


    def handle_file(self, filename):
        pass
    
    def get_suggestion(self, aDict):
        pass
    
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
            apps = DbSet.APPS
            
        ms = MatchSet()
        match_msgs = []
        properly_matched_count = 0
        sug_count = 0
        no_sug_count = 0        
        
        match_msgs.append("Checking files for '{}', apps:{} ".format(env.upper(), apps))
        
        for filename in filelist:
                        
            # the name of this file matches which of the apps?
            apps_for_file = [app for app in apps if re.search(app, filename)]
            
            # skip this file, if its none
            if not len(apps_for_file) :
                continue
            else:
                app_for_file = apps_for_file[0]
                  

            if write: 
                outfilename = FileUtils.get_output_filename(ConfigMgr.WORK_DIR,
                                                            ConfigMgr.OUTPUT_DIR,
                                                            filename)
            
            match_msgs.append('In file {}:'.format(filename))

            # read all lines of file into var
            with open(filename, 'r') as infile:
                lines = infile.readlines()

            cmiList = []
            linenum = 0
            outlines = ''

            # check lines
            for line in lines:
                linenum = linenum +1
                
                #properly_matched_prof = None
                                
                # Does this line look like a db?
                m = re.search(self.REGEX, line, re.IGNORECASE)
                if m:
                    m_boxname, m_dbname = m.group(1), m.group(2)
        
                    #cmi = ConnMatchInfo(m_boxname, m_dbname, linenum)
                    matched_profile = DbProfile(boxname=m_boxname, dbname=m_dbname,
                                                env=env, app=app_for_file)
                    
                    cmi = ConnMatchInfo(matched_profile, linenum)
                    
                    
                    
                    #print 'CHECK THIS', profDict
                    #profs = self.dbset.get(profDict)
                    sugg_profs = self.dbset.get(cmi.matchProf)
                    if len(sugg_profs):
                        # we have a perfect match already.
                        cmi.suggProf = sugg_profs[0]
                    
                    #print 'cmi matchProf ', cmi.matchProf
                    #print 'cmi is suggProf', cmi.suggProf
                    
                    
                    
                    # the sug is exact match, including the boxname
#                    if cmi.suggProf:
#                        properly_matched_prof = profs[0]
#                        cmi.suggProf = profs[0]
#                        properly_matched_count = properly_matched_count + 1

                    # if no (exact match) sug yet, get the correect prof for this app+dbname+env
                    if not cmi.suggProf:
                                                                                    
                        suggestions = self.dbset.get_by_atts(dict(dbname=cmi.matchProf.dbname, app=app_for_file, env=env))
                        
                        if len(suggestions):
                            #sug_count = sug_count + 1                             
                            cmi.suggProf = suggestions[0]
                            if write:
                                line = re.sub(m_boxname, cmi.suggProf.boxname, line, re.IGNORECASE)
                                match_msgs.append('    * Connection on line {} changing from {} to {}'.
                                                  format(linenum, m_boxname, cmi.suggProf.boxname))     
                        else:

                            #no_sug_count =  no_sug_count + 1
                            match_msgs.append('    ********** No suggestions for {} - {}'.format(app_for_file, env))
                    
                    cmiList.append(cmi)
                    
                            
                if write:
                    outlines = outlines + line

            ms.matches[filename] = sorted(cmiList, key = lambda x: x.linenum)

            if write:
                outfilename = FileUtils.get_output_filename(ConfigMgr.WORK_DIR, ConfigMgr.OUTPUT_DIR, filename)
                with open(outfilename, 'w') as outfile:
                    outfile.write(outlines)
                match_msgs.append('Wrote file ' + outfilename)
        
        #match_msgs.append(ms.match_dict_summary())
        
        if verbose:
            print os.linesep.join(match_msgs)
            print
        
        
        if  env: 
            
            # roughtly this, but i need an equals func
            #sug_count = len(cmi for cmi in cmiList if cmi.suggProf and cmi.suggProf is not cmi.matchProf)
            sug_count = 'fixthis'
            no_sug_count = 'fixthis'
            
            
            print '{0:3} matches are properly configured for {1}'.format(len([cmi for cmi in cmiList if cmi.matchProf == cmi.suggProf]), env)
            print '{0:3} matches have suggested changes.'.format(sug_count)
            print '{0:3} matches have no suggested changes.'.format(no_sug_count)
        
        print ms.match_dict_summary()
        return ms


if __name__ == "__main__":
    import doctest
    #doctest.testmod(verbose=True)
    doctest.testfile("tests/test_ConfigMgr.txt", verbose=True)
    sys.exit(0)
   


