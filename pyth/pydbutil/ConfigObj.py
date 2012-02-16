#! /usr/bin/python
""" The things being searched and managed. """
import sys
import os



COTYPES = ('LOG_A', 'LOG_B', 'DB', 'FTP', 'TO_VAL', 'FROM_VAL',
            'SMTP', 'SUBJ')


class ConfigObj(object):
    """ The things being searched and managed. """
    def __init__(self, cotype=None, regex=None, changeval=None):
        self.cotype = cotype
        self.regex = regex
        self.changeval = changeval
        if self.cotype and self.cotype not in COTYPES:
            raise Exception('{0} not valid cotype. {1}'.format
                            (self.cotype, COTYPES))

    @staticmethod
    def get_configs(configset='RDxETL') :
        """ Returns dict of configsobjs for configset set. """
        if configset == 'RDxETL' :

            FTP_ROOT = 'USHPEWVAPP251'
            LOG_PATH = r'D:\RDx\ETL\logs'
            SMTP_SERVER = 'usush-maildrop.amer.umusic.net'
            TO_VAL = 'ar.umg.rights.dev@hp.com, Scott.Hill@umgtemp.com'
            FROM_VAL = 'RDx@mgd.umusic.com'
            SUBJ = 'RDxAlert Message'
            CONFIG_OBJS = (ConfigObj('LOG_A', '<file value="(.+)"', LOG_PATH),
                            ConfigObj('LOG_B', '"file" value="(.+)"', LOG_PATH),
                            ConfigObj('DB', 'Data Source=(.+);Initial Catalog=(RDx\w+);', ''),
                            ConfigObj('FTP', r'"(.+)" value="\\\\(.+)\\d\$', FTP_ROOT),
                            ConfigObj('TO_VAL', '<to value="(.+)"', TO_VAL),
                            ConfigObj('FROM_VAL', '<from value="(.+)"', FROM_VAL),
                            ConfigObj('SMTP', '<smtpHost value="(.+)"', SMTP_SERVER),
                            ConfigObj('SUBJ', '<subject value="(.+)"', SUBJ))
            return dict(zip([co.cotype for co in CONFIG_OBJS], CONFIG_OBJS))
        else:
            raise Exception('Invalid configset', configset)

    @staticmethod
    def get_logname(logroot, app):
        """ Returns the path to the logfile based on the app name."""
        # logpath = configs['LOG_A'].changeval + "\\" + app
        # return logpath + "\\" + app + '_etl.txt'
        return os.path.join(logroot, app, app + '_etl.txt')

    def __str__(self):
        return '{0} {1} {2}'.format(self.cotype, self.regex, self.changeval)

    def __repr__(self):
        return str(self.__str__())

if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    sys.exit(0)



