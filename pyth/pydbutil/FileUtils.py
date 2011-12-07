#! /usr/bin/python
"""Some static file methods.

Usage:
"""
import os
import re

def get_filelist(path=None, skipdir='Common'):
    """Gets config files in given path. Walks ssubdirs.
    Skips dirs named <skipdir>..

    Usage:  
    >>> path = 'input/ETL/'
    >>> filelist = ConfigMgr.get_filelist(path)
    >>> print '{} files are in path {}'.format(len(filelist), path)
    23 files are in path input/ETL/
    """
    if not path: raise Exception('path is required for get_filelist.')
    filelist = []
    
    if os.path.isfile(path) :
        filelist.append(path)
    elif os.path.isdir(path) :
        for root, dirs, files in os.walk(path):
            if skipdir in dirs:
                dirs.remove(skipdir)
            for name in files:
                filepathname = os.path.join(root, name)
                ext = os.path.splitext(filepathname)[1]
                if ext == '.config':
                    filelist.append(filepathname)
    else: 
        msg = path  + ' does not exist.'
        raise Exception(msg)
    return filelist


def trim_line(self, longline, max_length=80, chars_trimmed=20, chars_shown=65):
    """Returns a block from the middle of the line, with ellipsis."""
    shortline = longline.strip()
    if len(shortline) > chars_shown and len(shortline) > chars_trimmed :
        shortline = '...' + shortline[chars_trimmed : chars_trimmed+chars_shown] + '...'
    return shortline

def get_output_filename(before, after, infilename):
    """ Returns path to ./outdir/filename. Creates if necc."""
    outfilename = re.sub(before, after, infilename)
    ensure_dir(outfilename)
    return outfilename

def ensure_dir(f):
    """ Creates the dirs to f if they don't already exist. """
    d = os.path.dirname(f)
    if not os.path.exists(d):
        os.makedirs(d)

