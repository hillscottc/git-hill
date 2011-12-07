#! /usr/bin/python
"""Handles database connection strings in files using DbProfiles.

Usage: go() is the main function. Many examples in tests below.
>>> from MatchSet import MatchSet
>>> cm = ConfigMgr(dbsource='input/DbSet.data.csv', path='input/ETL/MP/UMG.RDx.ETL.MP.vshost.exe.config')
>>> ms = cm.go(verbose=False)
>>> ms.match_dict_summary()
'Found 4 matches in 1 files.'
"""
import sys
import re
import os
from DbSet import DbSet
from ConnMatchInfo import ConnMatchInfo
from DbProfile import DbProfile
from MatchSet import MatchSet
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
    



    def go(self, filelist=None, app=None, env=None, write=False, verbose=True) :
        """Checks file for lines which contain connection string information,
        for each file in filelist.
            
        Usage:
        >>> cm = ConfigMgr(dbsource='input/DbSet.data.csv', path='input/ETL/MP/')
        >>> ms = cm.go(verbose=False)
        >>> ms.match_dict_summary()
        'Found 9 matches in 4 files.'
        >>> ms = cm.go(verbose=True, env='dev')
        Checking filelist for env: dev, apps: ('CARL', 'CPRS', 'CTX', 'Common', 'D2', 'DRA', 'MP', 'PartsOrder', 'R2', 'gdrs') 
        In file input/ETL/MP/log4net.config:
        In file input/ETL/MP/UMG.RDx.ETL.MP.exe.config:
          (usfshwssql104) RDxETL 8 matched [] from the dbset.
            * dbset profile for MP - dev is [[MP RDxETL dev usfshwssql104]]
          (usfshwssql104) RDxETL 13 matched [] from the dbset.
            * dbset profile for MP - dev is [[MP RDxETL dev usfshwssql104]]
          (usfshwssql104) RDxETL 17 matched [] from the dbset.
            * dbset profile for MP - dev is [[MP RDxETL dev usfshwssql104]]
          USFSHWSSQL104\RIGHTSDEV_2 RDxReport 21 matched [] from the dbset.
            * dbset profile for MP - dev is [[MP RDxReport dev usfshwssql104]]
        In file input/ETL/MP/UMG.RDx.ETL.MP.Extract.dll.config:
          usfshwssql104 RDxETL 10 matched [[MP RDxETL dev usfshwssql104]] from the dbset.
        In file input/ETL/MP/UMG.RDx.ETL.MP.vshost.exe.config:
          usfshwssql104 RDxETL 69 matched [[MP RDxETL dev usfshwssql104]] from the dbset.
          usfshwssql104 RDxETL 74 matched [[MP RDxETL dev usfshwssql104]] from the dbset.
          usfshwssql104 RDxETL 78 matched [[MP RDxETL dev usfshwssql104]] from the dbset.
          usfshwssql104 RDxReport 82 matched [[MP RDxReport dev usfshwssql104]] from the dbset.
        Found 9 matches in 4 files.
        """
        
        if not filelist:
            filelist = self.filelist
        if not filelist:
            raise Exception('filelist required.')
        
        if write:
#            if not env:
#                env = self.env
            if not env :
                raise Exception('env is required for write.')

        if app:
            apps = [app]
        else:
            apps = DbSet.APPS
            
        #ms = {}
        ms = MatchSet()
        match_msgs = []
        
        match_msgs.append("Checking filelist for env: {}, apps: {} ".format(env, apps))
        
        for filename in filelist:            
            
            
            # skip file if it doesnt have one of the apps in its name
            if not len([app for app in apps if re.search(app, filename)]) :
                continue
                
            #if not re.search(app, filename):
            #    continue

            if write: outfilename = FileUtils.get_output_filename(ConfigMgr.WORK_DIR, ConfigMgr.OUTPUT_DIR, filename)
            
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
                
                dbset_matches = []
                
                # print 'line {}:{}    {}'.format(str(linenum), os.linesep, self.trim_line(line))
                m = re.search(self.REGEX, line, re.IGNORECASE)
                if m:
                    m_boxname, m_dbname = m.group(1), m.group(2)
                    ci = ConnMatchInfo(m_boxname, m_dbname, linenum)
                    cmiList.append(ci)

                    
                    for app in apps:
                        if re.search(app, filename):
                            profDict = dict(boxname=ci.boxname.lower(), dbname=ci.dbname, env=env, app=app)
                            #print 'CHECK THIS', profDict
                            profs = self.dbset.get_profiles_by_attribs(profDict)
                            if profs:
                                dbset_matches.append (profs)


                    match_msgs.append('  {} matched {} from the dbset.'.format(ci, dbset_matches))
                    #print 'len of dbset_matches is {}'.format(len(dbset_matches))
                    if not dbset_matches:
                        db_sugestions = []
                                    
                        #print 'APPPPPP', [app for app in apps if re.search(app, filename)][0], filename
                        
                        app_to_check = [app for app in apps if re.search(app, filename)][0]
                        
                        profs = self.dbset.get_profiles_by_attribs(dict(dbname=ci.dbname,
                                                                        app=app_to_check,
                                                                        env=env))
                        #print 'GOT', profs, 'for' , filename, ci.dbname, app_to_check, env
                        
                        if profs:
                            db_sugestions.append(profs)
                            match_msgs.append('    * dbset profile for {} - {} is {}'.format(app_to_check, env, db_sugestions))
                        else:
                            match_msgs.append('    ********** No suggestions for {} - {}'.format(app_to_check, env))
                            
                        #db_sugestions = self.dbset.get_profiles_by_attribs(dict(dbname=ci.dbname, app=app, env=env))
                        
#                        for dbprof in db_sugestions:
#                            match_msgs.append('    * dbset profile for {}/{} is {}'.format(app, env, dbprof))
                        
                        #print 'db_sugestions is {}'.format(db_sugestions)
                        
                        if write and db_sugestions:
                            #print 'db_sugestions[0]===', db_sugestions[0]
                            prof = DbProfile(db_sugestions[0])
#                            if db_sugestions[0]:
#                                print 'WARN: using the first of multiple suggestions.'
                            line = re.sub(m_boxname, prof.boxname, line, re.IGNORECASE)
                            match_msgs.append('    * Connection on line {} changing from {} to {}'.
                                              format(linenum, m_boxname, prof.boxname))
                            
                if write: outlines = outlines + line

            # sort by linenum
            ms.matches[filename] = sorted(cmiList, key = lambda x: x.linenum)

            if write:
                outfilename = FileUtils.get_output_filename(ConfigMgr.WORK_DIR, ConfigMgr.OUTPUT_DIR, filename)
                with open(outfilename, 'w') as outfile:
                    outfile.write(outlines)
                match_msgs.append('Wrote file ' + outfilename)
        
        match_msgs.append(ms.match_dict_summary())
        
        if verbose:
            print os.linesep.join(match_msgs)
        
        return ms


if __name__ == "__main__":
    import doctest
    #doctest.testmod(verbose=True)
    doctest.testfile("tests/test_ConfigMgr.txt")
    sys.exit(0)
   


