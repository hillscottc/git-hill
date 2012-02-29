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



