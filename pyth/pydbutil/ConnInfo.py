#! /usr/bin/python

import sys


class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

class ConnInfo(object):
    """

    """

    def __init__(self, boxname, dbname, linenum):
        self.boxname = boxname
        self.dbname = dbname
        self.linenum = linenum

    def __str__(self):
        return '{} {} {}'.format(self.boxname, self.dbname, self.linenum)

    def __repr__(self):
        return str(self.__str__())

if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    sys.exit(0)
    #sys.exit(main())


    