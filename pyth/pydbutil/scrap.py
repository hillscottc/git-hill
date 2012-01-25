#! /usr/bin/python

from ConfigObj import ConfigObj
import pprint
import FileUtils


# FTP_ROOT = 'USHPEWVAPP251'
# LOG_PATH = r'D:\RDx\ETL\logs'
# SMTP_SERVER = 'usush-maildrop.amer.umusic.net'
# TO_VAL = 'ar.umg.rights.dev@hp.com, Scott.Hill@umgtemp.com'
# FROM_VAL = 'RDx@mgd.umusic.com'
# SUBJ = 'RDxAlert Message'


# CONFIG_OBJS = (ConfigObj('LOG_A', '<file value="(.+)"', LOG_PATH),
#                 ConfigObj('LOG_B', '"file" value="(.+)"', LOG_PATH),
#                 ConfigObj('DB', 'Data Source=(.+);Initial Catalog=(RDx\w+);', ''),
#                 ConfigObj('FTP', r'"(.+)" value="\\\\(.+)\\d\$', FTP_ROOT),
#                 ConfigObj('TO_VAL', '<to value="(.+)"', TO_VAL),
#                 ConfigObj('FROM_VAL', '<from value="(.+)"', FROM_VAL),
#                 ConfigObj('SMTP', '<smtpHost value="(.+)"', SMTP_SERVER),
#                 ConfigObj('SUBJ', '<subject value="(.+)"', SUBJ))

# configs = dict(zip([co.cotype for co in CONFIG_OBJS], CONFIG_OBJS))


# pprint.pprint(configs)



pprint.pprint(FileUtils.get_filelist('./remote', 'Backup', '.bat', '.config'))






