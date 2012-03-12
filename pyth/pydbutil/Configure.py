#! /usr/bin/python
""" To be imported by ConfigMgr classes """
import os
import re
import sys
import time
import subprocess
import pprint
import logging
from DbSet import DbSet
from DbProfile import DbProfile
from ConfigObj import ConfigObj

class Error(Exception):
    def __init__(self, msg):
        self.msg = msg


APPS = ('CARL', 'CART', 'Common', 'CPRS','CRA', 'CTX', 'D2',
        'DRA', 'ELS', 'GDRS', 'MP', 'PartsOrder', 'R2')

_dbs = (('RDxETL', 'USHPEPVSQL409'), ('RDxReport', 'USHPEPVSQL435'))
_envs = ('dev', )

DBSET = DbSet(DbProfile.create_profiles(envs=_envs, apps=APPS, dbs=_dbs))


_ftp_root = 'USHPEWVAPP251'
_log_path = os.path.join('D:', 'RDx', 'ETL', 'logs')
_smtp_server = 'usush-maildrop.amer.umusic.net'
_to = 'ar.umg.rights.dev@hp.com, Scott.Hill@umgtemp.com'
_from = 'RDx@mgd.umusic.com'
_subj = 'RDxAlert Message'
_configs = (ConfigObj('LOG_A', '<file value="(.+)"', _log_path),
                ConfigObj('LOG_B', '"file" value="(.+)"', _log_path),
                ConfigObj('DB', 'Data Source=(.+);Initial Catalog=(RDx\w+);', ''),
                ConfigObj('FTP', r'"(.+)" value="\\\\(.+)\\d\$', _ftp_root),
                ConfigObj('TO_VAL', '<to value="(.+)"', _to),
                ConfigObj('FROM_VAL', '<from value="(.+)"', _from),
                ConfigObj('SMTP', '<smtpHost value="(.+)"', _smtp_server),
                ConfigObj('SUBJ', '<subject value="(.+)"', _subj))

CONFIGS =  dict(zip([co.cotype for co in _configs], _configs))

