#! /usr/bin/python
"""Handles database connection strings in files using DbProfiles.

Usage: go() is the main function. Many examples in tests below.
>>> from MatchSet import MatchSet
>>> from DbSet import DbSet
>>> from DbProfile import DbProfile
>>> APPS = ('CARL', 'CART')
>>> DBS = (('RDxETL', 'USHPEPVSQL409'), ('RDxReport', r'USHPEPVSQL435'))
>>> ENVS = ('dev',)
>>> MODEL_DBSET = DbSet(DbProfile.create_profiles(envs=ENVS, apps=APPS, dbs=DBS))
>>> cm = ConfigMgr(dbset=MODEL_DBSET, path='remote')
"""
import sys
import re
import os
from MatchedConfig import MatchedConfig
from MatchSet import MatchSet
from ConfigObj import ConfigObj
from DbProfile import DbProfile
from collections import namedtuple
import FileUtils
import logging
from pprint import pformat
#from pprint_data import data

logger = logging.getLogger('ConfigMgr')
logger.setLevel(logging.DEBUG)
#create file handler which logs even debug messages
fh = logging.FileHandler('logs/ConfigMgr.log')
fh.setLevel(logging.DEBUG)
# create console handler with a higher log level
ch = logging.StreamHandler()
ch.setLevel(logging.WARN)
# create formatter and add it to the handlers
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
fh.setFormatter(formatter)
ch.setFormatter(formatter)
# add the handlers to the logger
logger.addHandler(fh)
logger.addHandler(ch)



class ConfigMgr(object):
    """Handles database connection strings in files using DbProfiles."""

    #WORK_DIR = os.path.join(os.getcwd(), 'work')
    WORK_DIR = os.path.join(os.getcwd(), 'work')
    OUTPUT_DIR = os.path.join(os.getcwd(), 'output')

    FTP_ROOT = 'USHPEWVAPP251'
    LOG_PATH = r'D:\RDx\ETL\logs'
    SMTP_SERVER = 'usush-maildrop.amer.umusic.net'
    TO_VAL = 'ar.umg.rights.dev@hp.com, Scott.Hill@umgtemp.com'
    FROM_VAL = 'RDx@mgd.umusic.com'
    SUBJ = 'RDxAlert Message'

    CONFIG_OBJS = (ConfigObj('LOG_A', '<file value="(.+)"'),
                    ConfigObj('LOG_B', '"file" value="(.+)"'),
                    ConfigObj('DB', 'Data Source=(.+);Initial Catalog=(RDx\w+);'),
                    ConfigObj('FTP', r'"(.+)" value="\\\\(.+)\\d\$'),
                    ConfigObj('TO_VAL', '<to value="(.+)"', TO_VAL),
                    ConfigObj('FROM_VAL', '<from value="(.+)"', FROM_VAL),
                    ConfigObj('SMTP', '<smtpHost value="(.+)"', SMTP_SERVER),
                    ConfigObj('SUBJ', '<subject value="(.+)"', SUBJ)
                    )


    def __init__(self, dbset=None, path=None, env=None, write=False, verbose=True):
        self.dbset = dbset
        self.path = path
        self.env = env
        self.write = write
        self.verbose = verbose


    def set_path(self, value):
        if not self.dbset: raise Exception('dbset is required when setting path.')
        self.filelist = FileUtils.get_filelist(value, skipdir='Backup')
        #print 'Set path to ' + value
        self._path = value

    def get_path(self):
        return self._path

    path = property(get_path, set_path)


    def get_logname(self, app):
        #logpath = os.path.join(self.LOG_PATH, app)
        logpath = self.LOG_PATH + "\\" + app
        return logpath + "\\" + app + '_etl.txt'


    def get_mc(self, line, env, app):
        """ Returns: MatchedConfig for given line if it matches any of the CONFIG_OBJS."""
        
        mc = None
        co = None
        m = None
        
        # which of the co's does this line match?
        for c in self.CONFIG_OBJS:
            m = re.search(c.regex, line, re.IGNORECASE)
            if m:
                co = c
                break
        
        if not co:
            return None
        else :
            if co.cotype in ('SMTP', 'TO_VAL', 'FROM_VAL', 'SUBJ') :
                
                mc = MatchedConfig(mtype=co.cotype, before=m.group(1), after=co.changeval)
                                                    
            elif co.cotype in ('LOG_A', 'LOG_B') :

                mc = MatchedConfig(mtype=co.cotype, before=m.group(1), after=self.get_logname(app))

            elif co.cotype is 'FTP':

                mc = MatchedConfig(mtype=co.cotype, before=m.group(2),
                                   after=self.FTP_ROOT, newname=m.group(1))

            elif co.cotype is 'DB':
                #mc = self.parse_line_db(m, line, env, app)
                
                matched_profile = DbProfile(
                                   boxname=m.group(1).upper(),
                                   dbname=m.group(2),
                                   env=env, app=app)

                mc = MatchedConfig(mtype='DB', before=matched_profile,
                                   before_raw=m.group(1))

                sugg_profs = self.dbset.get(mc.before)

                if len(sugg_profs):
                    # we have a perfect match already.
                    mc.after = sugg_profs[0]

                # if no (exact match) sug yet, get the correect prof for this app+dbname+env
                if not mc.after:
                    #print '####', mc.before, 'was  not', mc.after
                    suggestions = self.dbset.get_by_atts(
                                   dict(dbname=mc.before.dbname, app=app, env=env))

                    if len(suggestions):
                        mc.after = suggestions[0]                
                
            else :
                raise 'why it not one of these-a-ones'
            
        return mc




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

        logger.debug('GO !!!!!!!!!!!!!!!')
        logger.debug('ENV:%s    APPS:%s', env, apps)
        #logger.debug('   APPS : %s', apps)

        ms = MatchSet()

        for filename in filelist:

            # the name of this file matches which of the apps?
            apps_for_file = [app for app in apps if re.search(app, filename, re.IGNORECASE)]

            # skip this file, if its none
            if not len(apps_for_file) :
                logger.debug('**************************Skipping file', filename)
                continue
            else:
                app = apps_for_file[0]


            # read all lines of file into var
            with open(filename, 'r') as infile:
                lines = infile.readlines()

            mcList = []
            linenum = 0
            outlines = ''

            # check lines
            for line in lines:
                linenum = linenum +1
                
                mc = self.get_mc(line, env, app)
                
                if mc:
                    mc.linenum = linenum
                    mcList.append(mc)  
                    if write:
                        if mc.mtype in ('SMTP', 'TO_VAL', 'FROM_VAL', 'SUBJ', 'FTP') :
                            line = re.sub(mc.before, mc.after, line, re.IGNORECASE)
                        elif mc.mtype in  ('LOG_A', 'LOG_B') :
                            line = re.sub(re.escape(mc.before), mc.after, line, re.IGNORECASE)
                        elif mc.mtype is  'DB' :
                            #line = re.sub(re.escape(m.group(1)), mc.after.boxname, line, re.IGNORECASE)
                            line = re.sub(re.escape(mc.before_raw), mc.after.boxname, line, re.IGNORECASE)
                        else :
                            raise 'why it not one of em?'
                    
                outlines = outlines + line


            ms.matches[filename] = sorted(mcList, key = lambda x: x.linenum)

            if write:
                outfilename = FileUtils.get_output_filename(
                               ConfigMgr.WORK_DIR, ConfigMgr.OUTPUT_DIR, filename)
                with open(outfilename, 'w') as outfile:
                    outfile.write(outlines)

        #logger.debug('SUMMARY...........................................' + os.linesep + ms.summary_details())
        logger.debug('')
        #logger.debug(os.linesep.join([(str(k) + os.linesep) + pformat(v) for k, v in ms.matches.iteritems()]))

        for k in ms.matches.keys():
            logger.debug('%s', k)
            for v in ms.matches[k]:
                logger.debug('  %s', v)



        logger.debug('')
        logger.debug(ms.summary_matches())
        return ms


if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    #doctest.testfile("tests/test_ConfigMgr.txt", verbose=True)
    sys.exit(0)



