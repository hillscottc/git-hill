#! /usr/bin/python
"""Manages a set of matches.

Usage:
"""
import sys
import itertools
from ConnMatchInfo import ConnMatchInfo


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
        
    def get_all_matches(self):
        """ all the matches in all the lists """
        all_lists = [cmiList for cmiList in self.matches.values()]
        all_matches = [cmi for cmi in all_lists]
        # flatten. dont want a lists of lists. 
        return  list(itertools.chain(*all_matches))
        
    def match_count(self):
        """ count of matches in all files """
        sum(len(cmiList) for cmiList in self.matches.values())

    def get_match_files(self, with_matches=True):
        """ Returns files with or without matches.
        """
        if with_matches:
            return [k for k, v in self.matches.iteritems() if len(v) > 1]
        else:
            return [k for k, v in self.matches.iteritems() if len(v) == 0]
        
    def get_new_filenames(self):
        """ Returns files with or without matches.
        """
        outfilenames = []
        for filename in self.matches.keys() :
            for cmi in self.matches[filename]:
                if cmi.suggProf:
                    outfilenames.append(cmi.newFilename)
                break
        return outfilenames

      

    def match_dict_summary(self):
        """
        """
        return '{0:3} total matches in {1} files.'.format(sum([len(v) for v in self.matches.values()]),
                                                      len(self.matches.keys()))



if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    sys.exit(0)

