#! /usr/bin/python
"""Manages a set of matches.

Usage:
"""
import sys
import os
import itertools
from MatchConn import MatchConn
from MatchLog import MatchLog

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
    >>> ms.summary_matches()
    'Found 6 matches in 3 files.'
    """
    
    
    def __init__(self, **matches):
        self.matches = matches
        
    def get_all_matches(self):
        """ all the matches in all the lists """
        all_lists = [maList for maList in self.matches.values()]
        all_matches = [ma for ma in all_lists]
        # flattens. dont want a list of lists. 
        return  list(itertools.chain(*all_matches))
        
        
    def get_files_with_matches(self, matches=True):
        if matches:
            return [k for k, v in self.matches.iteritems() if len(v)]
        else:
            return [k for k, v in self.matches.iteritems() if not len(v)]   
        
        
    def get_new_filenames(self):
        outfilenames = []
        for filename in self.matches.keys() :
            for cmi in self.matches[filename]:
                if cmi.after:
                    outfilenames.append(cmi.newFilename)
                break
        return outfilenames
    
    
    def get_files_processed(self):
        return self.matches.keys()
   
    
    def summary_files(self):
        
        lines = []
        
        lines.append('{0:3} .config files found.'.format
                     (len(self.get_files_processed())))

        lines.append('{0:3} files with NO matches.'.format
                     (len(self.get_files_with_matches(False))))

        lines.append('{0:3} files with at least one match.'.format
                     (len(self.get_files_with_matches())))  
                
        return os.linesep.join(lines)    
    
    
    def summary_matches(self):
        
        lines = []
 
        lines.append('{0:3} total matches in {1} files.'.format
                     (sum([len(v) for v in self.matches.values()]),
                       len(self.get_files_processed()) ))
        
        lines.append('{0:3} matches were already properly configured.'.format
                     (len([ma for ma in self.get_all_matches() 
                           if ma.before == ma.after])))        
        
        lines.append('{0:3} matches had suggested changes.'.format
                     (len([ma for ma in self.get_all_matches() 
                           if ma.before != ma.after])))            
        
        lines.append('{0:3} matches had NO suggestions.'.format
                     (len([ma for ma in self.get_all_matches() 
                           if not ma.after])))   
                
        return os.linesep.join(lines)
    
    def summary_details(self):
        
        lines = []
        
        for filename in self.matches.keys() :
            lines.append('FILE: ' + filename)
            for ma in self.matches[filename]:
                if isinstance(ma, MatchConn): 
                    l = '  line {}, {} is pointed to {}'.format(ma.linenum, ma.before.dbname, ma.before.boxname)
                    if ma.after == ma.before:
                        l += '...already matching {} ...no change.'.format(ma.after.boxname)      
                    elif ma.after:
                        l += '...changing to {}'.format(ma.after.boxname)
                    else:
                        l +=  '...no suggestions...no change.' 
                    lines.append(l) 
                elif isinstance(ma, MatchLog):
                    l = '  line {}, log is pointed to {}'.format(ma.linenum, ma.before)
                    if ma.after == ma.before:
                        l += '...already correct...no change.'   
                    elif ma.after:
                        l += '...changing to {}'.format(ma.after)
                    else:
                        l +=  '...no suggestions...no change.' 
                    lines.append(l)                     
                    pass
        
        return os.linesep.join(lines)    
        

if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    sys.exit(0)

