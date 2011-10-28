#! /usr/bin/python
""" Profile of a database instance."""

import sys
import getopt

ENVS = ['DEV', 'UAT', 'PROD']

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg


class DbProfile():
    """ Used to describe a database instance. """

    Keys = ('dbname', 'env', 'boxname', 'path')

    def __init__(self, dbname='RDxETL', env='UAT', boxname='usfshwssql104',
                 path='somepath'):
        self.dbname = dbname
        self.env = env
        self.boxname = boxname
        self.path = path

    def __str__(self):
        return self.dbname + ' ' + self.env + ' ' + self.boxname + ' ' + self.path
    def __repr__(self):
        return str(self.__str__())
    def get_key(self):
        # key is a tuple
        return (self.dbname, self.env)


def get_profile_from_tuple(tup):
    """ Create a profile from tuple of values."""
    db_dict = dict(zip(DbProfile.Keys, tup))
    return DbProfile(**db_dict)


def main(argv=None):
    if argv is None:
         argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(argv[1:], "hi:", ["help"])
        except getopt.error, msg:
            raise Usage(msg)

        for opt, arg in opts :
            if opt in ("-h", "--help"):
                print __doc__
                sys.exit(0)

        print 'Create dbprofile from default -- ', DbProfile()

        print 'Create dbprofile from tuple -- {}'.format(
            get_profile_from_tuple(('RDxETL', 'PROD', 'usfshwssql077', r'D:\Something')))

    except Usage, err:
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:",err.msg
        return 2

if __name__ == "__main__":
    sys.exit(main())