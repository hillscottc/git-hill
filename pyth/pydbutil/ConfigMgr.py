#! /usr/bin/python
"""Handles database connection strings in files using DbProfiles. """
import sys
import re
import os
import shutil
import fileinput
from MatchedConfig import MatchedConfig
from ConfigObj import ConfigObj
from DbProfile import DbProfile
from DbSet import DbSet
from collections import namedtuple
import FileUtils
import logging
import Configure
import MatchReport



class MyError(Exception):
    def __init__(self, value):
         self.value = value
    def __str__(self):
         return repr(self.value)

class ConfigMgr(object):
    """Handles database connection strings in files using DbProfiles.
    Usage:
    >>> from ConfigObj import ConfigObj
    >>> from DbSet import DbSet
    >>> import Configure
    >>> FILE_EXTS = ('.config', '.bat')
    >>> MODEL_DBSET = Configure.DBSET
    >>> CONFIGS = ConfigObj.get_configs('RDxETL')
    >>> workfiles = FileUtils.get_filelist(ConfigMgr.WORK_DIR, *FILE_EXTS)
    >>> cm = ConfigMgr(dbset=MODEL_DBSET, filelist=workfiles, configs=CONFIGS) # doctest: +ELLIPSIS
    Filelist set to ... files
    """
    WORK_DIR = os.path.join(os.getcwd(), 'work')
    OUTPUT_DIR = os.path.join(os.getcwd(), 'output')

    def __init__(self, dbset=None, configs=None, env=None,
                file_exts=None, filelist=None, write=False):
        self.dbset = dbset
        self.env = env
        self.write = write
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
    def update_file(filename, mcs) :
        """Upddates (rewrites) file by updating lines found in the mcs."""
        try:
            # iterates file and writes by redirects of print (STDOUT) to the file
            for i, line in enumerate(fileinput.input(filename, inplace = 1)) :
                if i not in (mc.linenum for mc in mcs):
                    print line,
                    continue
                mc = [mc for mc in mcs if mc.linenum is i][0]
                if mc.mtype in ('SMTP', 'TO_VAL', 'FROM_VAL', 'SUBJ', 'FTP') :
                    print re.sub(mc.before, mc.after, line, re.IGNORECASE),
                elif mc.mtype in  ('LOG_A', 'LOG_B') :
                    print re.sub(re.escape(mc.before), mc.after, line, re.IGNORECASE),
                elif mc.mtype is  'DB' :
                    print re.sub(re.escape(mc.before_raw), mc.after.boxname, line, re.IGNORECASE),
                else :
                    raise MyError('Should be a list type, not {0}'.format(mc.mtype))
        except Exception as e:
            raise MyError(e)


    def parse_line(self, linenum, line, env, app):
        """
        Returns: MatchedConfig for given line if matches any CONFIG_OBJS.
        mtype will be None if no match.
        """
        mc = MatchedConfig(mtype=None, linenum=linenum, app=app)
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
            if mc.mtype in ('SMTP', 'TO_VAL', 'FROM_VAL', 'SUBJ') :
                mc.before = m.group(1)
                mc.after = co.changeval
            elif mc.mtype in ('LOG_A', 'LOG_B') :
                mc.before = m.group(1)
                mc.after = ConfigObj.get_logname(self.configs['LOG_A'].changeval, app)
            elif mc.mtype == 'FTP':
                mc.before = m.group(2)

                # maybe changeval or get_log_name?
                mc.after = self.configs['FTP'].changeval

                mc.newname = m.group(1)
            elif mc.mtype == 'DB':
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
                raise MyError('why it not one of these-a-ones, not ' + mc.mtype)

            logging.debug('MATCH: {0}'.format(mc))

        return mc


    def parse_file(self, filename, app, env):
        """ Returns mclist for the file. """
        logging.debug('FILE: {0}, {1}, {2}'.format(filename, app, env))
        mcList = []
        with open(filename, 'r') as infile:
            lines = infile.readlines()
        for i, line in enumerate(lines):
            mc = self.parse_line(i, line, env, app)
            if mc.mtype:
                mcList.append(mc)
        logging.debug('MATCHLIST COUNT: {0}'.format(len(mcList)))
        return mcList


    def go(self, app=None, write=False) :
        """
        Checks file for lines which contain connection string information,
        for each file in filelist.
        Returns: a dict of matches
        """

        filelist = self.filelist
        if not filelist:
            raise Exception('filelist required.')

        # the first in the env list. (Needs fixing. Do I need it at all?)
        env = Configure._envs[0]

        if app:
            apps = [app]
        else:
            apps = Configure.APPS

        logging.debug('GO !')
        logging.debug('ENV:%s    APPS:%s', env, apps)

        md = {}

        for filename in filelist:
            # mcs for this file
            mcs = None

            # the name of this file matches which of the apps?
            app = MatchReport.get_file_app(filename)
            if not app:
                logging.info('** Skipping file {0}'.format(filename))
                continue

            # parse the file
            mcs = self.parse_file(filename, app, env)

            # sort mcs and append to dict keyed by file
            md[filename] = sorted(mcs, key = lambda x: x.linenum)

            # do line replacements on file
            if write:
                ConfigMgr.update_file(filename, mcs)

        # copy work dir to output dir
        if write:
            if os.path.exists(ConfigMgr.OUTPUT_DIR):
                shutil.rmtree(ConfigMgr.OUTPUT_DIR)
            shutil.copytree(ConfigMgr.WORK_DIR, ConfigMgr.OUTPUT_DIR)

        logging.debug('')
        logging.debug(MatchReport.details(md, apps=apps))
        logging.debug(MatchReport.summary(md, self.configs))

        return md

if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    #doctest.testfile("tests/test_ConfigMgr.txt", verbose=True)
    sys.exit(0)



