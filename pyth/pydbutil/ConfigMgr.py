#! /usr/bin/python
"""Handles database connection strings in files using DbProfiles.

Usage: go() is the main function. Many examples in tests below.

>>> from ConfigObj import ConfigObj
>>> from DbSet import DbSet
>>> FILE_EXTS = ('.config', '.bat')
>>> MODEL_DBSET = DbSet.get_dbset('RDxETL')
>>> CONFIGS = ConfigObj.get_configs('RDxETL')
>>> workfiles = FileUtils.get_filelist(ConfigMgr.WORK_DIR, *FILE_EXTS)
>>> cm = ConfigMgr(dbset=MODEL_DBSET, filelist=workfiles, configs=CONFIGS)
Filelist set to 35 files
"""
import sys
import re
import os
from MatchedConfig import MatchedConfig
from MatchSet import MatchSet
from ConfigObj import ConfigObj
from DbProfile import DbProfile
from DbSet import DbSet
from collections import namedtuple
import FileUtils
import logging



class ConfigMgr(object):
    """Handles database connection strings in files using DbProfiles."""

    WORK_DIR = os.path.join(os.getcwd(), 'work')
    OUTPUT_DIR = os.path.join(os.getcwd(), 'output')

    def __init__(self, dbset=None, configs=None, env=None,
                 file_exts=None, filelist=None, write=False, verbose=True):
        self.dbset = dbset
        self.env = env
        self.write = write
        self.verbose = verbose
        self.configs = configs
        if not self.configs:
            raise 'configs required.'
        self.file_exts = file_exts
        if not file_exts:
            # default
            self.file_exts = ('.config',)
        #self.path = path
        if filelist:
            self.filelist = filelist


    def get_filelist(self):
        return self._filelist

    def set_filelist(self, value):
        """Setting the path sets the filelist."""
        print 'Filelist set to {0} files'.format(len(value))
        self._filelist = value

    filelist = property(get_filelist, set_filelist)




    @staticmethod
    def get_logname(configs, app):
        # or, logpath = os.path.join(self.LOG_PATH, app)
        logpath = configs['LOG_A'].changeval + "\\" + app
        return logpath + "\\" + app + '_etl.txt'

    @staticmethod
    def get_newlines(filename, mcs):
        """ gets set of modded lines for given mcs """
        with open(filename, 'r') as infile:
             lines = infile.readlines()
        newlines = ""
        for i, line in enumerate(lines) :
            if i not in (mc.linenum for mc in mcs):
                #newlines.append(line)
                newlines += line
                continue
            mc = [mc for mc in mcs if mc.linenum is i][0]
            if mc.mtype in ('SMTP', 'TO_VAL', 'FROM_VAL', 'SUBJ', 'FTP') :
                line = re.sub(mc.before, mc.after, line, re.IGNORECASE)
            elif mc.mtype in  ('LOG_A', 'LOG_B') :
                line = re.sub(re.escape(mc.before), mc.after, line, re.IGNORECASE)
            elif mc.mtype is  'DB' :
                #line = re.sub(re.escape(m.group(1)), mc.after.boxname, line, re.IGNORECASE)
                line = re.sub(re.escape(mc.before_raw), mc.after.boxname, line, re.IGNORECASE)
            else :
                raise 'why it not one of em?'
            #newlines.append(line)
            newlines += line
        return newlines


    def parse_line(self, linenum, line, env, app):
        """
        Returns: MatchedConfig for given line if matches any CONFIG_OBJS.
        mtype will be None if no match.
        """
        mc = MatchedConfig(mtype=None, linenum=linenum)
        co = None
        m = None

        # which of the co's does this line match?
        for c in self.configs.values():
            m = re.search(c.regex, line, re.IGNORECASE)
            if m:
                co = c
                break

        if not co:
            return mc
        else :
            mc.mtype = co.cotype
            if co.cotype in ('SMTP', 'TO_VAL', 'FROM_VAL', 'SUBJ') :
                mc.before = m.group(1)
                mc.after = co.changeval
            elif co.cotype in ('LOG_A', 'LOG_B') :
                mc.before = m.group(1)
                mc.after = ConfigMgr.get_logname(self.configs, app)
            elif co.cotype is 'FTP':
                mc.before = m.group(2)

                # maybe changeval or get_log_name?
                mc.after = self.configs['FTP'].changeval

                mc.newname = m.group(1)
            elif co.cotype is 'DB':
                m_prof = DbProfile(boxname=m.group(1).upper(),
                                   dbname=m.group(2),
                                   env=env, app=app)
                mc.before = m_prof
                mc.before_raw = m.group(1)

                # perfact match already?
                if len(self.dbset.get(mc.before)):
                    mc.after = (self.dbset.get(mc.before))[0]

                # if no perfect match, get suggested profs by
                # getting matches for this app + dbname + env
                if not mc.after:
                    sugs = self.dbset.get_by_atts(
                                   dict(dbname=mc.before.dbname, app=app, env=env))
                    if len(sugs):
                        mc.after = sugs[0]

            else :
                raise 'why it not one of these-a-ones'
        return mc


    def parse_file(self, filename, app, env):
        """ Returns mclist for the file. """
        mcList = []
        with open(filename, 'r') as infile:
            lines = infile.readlines()
        for i, line in enumerate(lines):
            mc = self.parse_line(i, line, env, app)
            if mc.mtype:
                mcList.append(mc)
        return mcList


    def go(self, filelist=None, app=None, env=None, write=False, verbose=True) :
        """
        Checks file for lines which contain connection string information,
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

        logging.debug('GO !!!!!!!!!!!!!!!')
        logging.debug('ENV:%s    APPS:%s', env, apps)

        ms = MatchSet()

        for filename in filelist:
            # mcs for this file
            mcs = None

            # the name of this file matches which of the apps?
            app = next((app for app in apps if re.search(app, filename, re.IGNORECASE)), None)
            if not app:
                logger.debug('* Skipping file', filename)
                continue

            # parse the file
            mcs = self.parse_file(filename, app, env)

            # sort mcs and append to dict keyed by file
            ms.matches[filename] = sorted(mcs, key = lambda x: x.linenum)

            if write:
                outfilename = FileUtils.get_outfilename(ConfigMgr.WORK_DIR,
                                ConfigMgr.OUTPUT_DIR, filename)
                outlines = ConfigMgr.get_newlines(filename, mcs)

                with open(outfilename, 'w') as outfile :
                     outfile.write(outlines)

        logging.debug('')
        logging.debug(ms.summary_matches(self.configs))
        return ms


if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    #doctest.testfile("tests/test_ConfigMgr.txt", verbose=True)
    sys.exit(0)



