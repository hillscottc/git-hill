#! /usr/bin/python
"""Some static file methods.

Usage:
"""
import os
import re
import shutil
import sys
import time
import subprocess


def get_work_path(path, old_dir, new_dir='work'):
    """
    Usage:
    >>> get_work_path('./remote/ETL/D2/_log4net.config',  './remote')
    'work/ETL/D2/_log4net.config'
    """
    return re.sub(old_dir, new_dir, path)

def get_filelist(path=None, *extentions):
    """
    Gets config files in given path. Walks subdirs.
    Skips dirs named <skipdir>. Skips files with spaces in path.
    Usage:
    >>> path = 'input/ETL/'
    >>> filelist = get_filelist(path)
    >>> print '{} files are in path {}'.format(len(filelist), path)
    23 files are in path input/ETL/
    """
    skipdir='Backup'
    if not path: raise Exception('path is required for get_filelist.')
    filelist = []

    print extentions

    if os.path.isfile(path) :
        filelist.append(path)
    elif os.path.isdir(path) :
        for root, dirs, files in os.walk(path):
            if skipdir in dirs:
                dirs.remove(skipdir)
                #print 'skipping', skipdir
            for name in files:
                filepathname = os.path.join(root, name)
                ext = os.path.splitext(filepathname)[1]
                if ext in extentions:
                    filelist.append(filepathname)
    else:
        msg = path  + ' does not exist.'
        raise Exception(msg)
    return filelist


def trim_line(longline, max_length=80, chars_trimmed=20, chars_shown=65):
    """Returns a block from the middle of the line, with ellipsis."""
    shortline = longline.strip()
    if len(shortline) > chars_shown and len(shortline) > chars_trimmed :
        shortline = '...' + shortline[chars_trimmed : chars_trimmed+chars_shown] + '...'
    return shortline

def get_bak_dir(path) :
    """
    >>> print get_bak_dir('remote/ETL')
    bak/.../remote/ETL
    """
    if os.path.isdir(path) :
        t = time.strftime('%m%d%H%M%S')
        return os.path.join('bak', t, os.path.relpath(path))
    else:
        raise Exception('Must supply a valid dir. Bad path:', path)



def get_outfilename(before, after, infilename):
    """ Returns path to ./outdir/filename. Creates if necc."""
    outfilename = re.sub(before, after, infilename)
    ensure_dir(outfilename)
    return outfilename

def ensure_dir(f):
    """ Creates the dirs to f if they don't already exist. """
    d = os.path.dirname(f)
    if not os.path.exists(d):
        os.makedirs(d)

def copy_files(sourcepaths, targpaths, ask=True):
    #import pdb; pdb.set_trace()
    if ask:
        print
        print 'The copying will be:'
        #print os.linesep.join(map('FROM {0}\nTO   {1}'.format, sourcepaths, targpaths))
        r = raw_input('Proceed with copy? [y]/n ')
        if r.lower() == 'n':
            print 'Ok, stopping.'
            sys.exit(0)
    [ensure_dir(f) for f in targpaths]
    map(shutil.copy, sourcepaths, targpaths)



