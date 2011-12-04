#! /usr/bin/python
"""Manages a set of matches.

Usage:
"""
import sys
#from ConnMatchInfo import ConnMatchInfo

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

class MatchSet(object):
    """Manages a set of matches.
    Usage:
    >>> import os
    >>> from ConnMatchInfo import ConnMatchInfo
    >>> cmi1 = (ConnMatchInfo('Usfshwssql104', 'RDxETL', 5), ConnMatchInfo('Usfshwssql104', 'RDxReport', 10))
    >>> cmi2 = (ConnMatchInfo('Usfshwssql99', 'RDxETL', 5), ConnMatchInfo('Usfshwssql99', 'RDxReport', 10)) 
    >>> cmi3 = (ConnMatchInfo('Usfshwssql88', 'RDxETL', 5), ConnMatchInfo('Usfshwssql88', 'RDxReport', 10))        
    >>> md = dict(file1=cmi1, file2=cmi2)
    >>> ms = MatchSet(**md)
    >>> print os.linesep.join(['{} {}'.format(k, v) for k, v in ms.matches.iteritems()])
    file2 (Usfshwssql99 RDxETL 5, Usfshwssql99 RDxReport 10)
    file1 (Usfshwssql104 RDxETL 5, Usfshwssql104 RDxReport 10)
    >>> ms.matches['file3'] = cmi3
    >>> print os.linesep.join(['{} {}'.format(k, v) for k, v in ms.matches.iteritems()])
    file3 (Usfshwssql88 RDxETL 5, Usfshwssql88 RDxReport 10)
    file2 (Usfshwssql99 RDxETL 5, Usfshwssql99 RDxReport 10)
    file1 (Usfshwssql104 RDxETL 5, Usfshwssql104 RDxReport 10)
    >>> ms.match_dict_summary()
    'Found 6 matches in 3 files.'
    """
    
    
    def __init__(self, **matches):
        self.matches = matches

    def get_match_files(self, with_matches=True):
        """ Returns files with or without matches.
        """
        if with_matches:
            return [k for k, v in self.matches.iteritems() if len(v) > 1]
        else:
            return [k for k, v in self.matches.iteritems() if len(v) == 0]

    def match_dict_summary(self):
        """
        """
        return 'Found {} matches in {} files.'.format(sum([len(v) for v in self.matches.values()]),
                                                      len(self.matches.keys()))

        
#    def set_cvsfile(self, value):
#        dr = csv.DictReader(open(value, 'rb'), delimiter=',', quotechar="'")
#        dbprofiles = [DbProfile(**row) for row in dr]    
#        self.DB = [db for db in dbprofiles]
#        self._cvsfile = value
#        
#    def get_cvsfile(self):
#        return self._cvsfile
#
#    cvsfile = property(get_cvsfile, set_cvsfile)
#
#    def __len__(self):
#        return len(self.DB)
#
#    def get_profiles_by_attribs(self, aDict):
#        """Does given dict of attrib-vals match with self data?
#        
#        Usage:
#        >>> dbset = DbSet('input/DbSet.data.csv')
#        
#        Have a training RDxETL?
#        >>> print dbset.get_profiles_by_attribs(dict(env='training', dbname='RDxETL'))
#        []
#        
#        What are the MP dev boxes?
#        >>> print dbset.get_profiles_by_attribs(dict(app='MP', env='dev'))
#        [MP RDxETL dev usfshwssql104, MP RDxReport dev usfshwssql104\RIGHTSDEV_2]
#        
#        What are the CARL boxes? (shows example of localhost or (loca) setting for db)
#        >>> print dbset.get_profiles_by_attribs(dict(app='CARL'))        
#        [CARL RDxETL dev (local), CARL RDxReport dev localhost]
#        """
#        profiles = []
#        for db in self.DB:
#            if db.match_attrib(aDict):
#                profiles.append(db)
#                #return db
#        return profiles
#
#    def __str__(self):
#        return str([str(dbprofile) for dbprofile in self.DB])  
#    def __repr__(self):
#        return str(self.__str__())


if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    sys.exit(0)

