#! /usr/bin/python
""" Some static file methods.
Usage: Any of the funcs can be called from the bash shell. (See main)
-> ./FileUtils.py "filecount('./temp')"

 """
import os
import re
import sys
import time
import subprocess
import pprint
import logging
from shutil import rmtree, copy, ignore_patterns, copytree

class Error(Exception):
    def __init__(self, msg):
        self.msg = msg


def trim_line(longline, max_length=80, chars_trimmed=20, chars_shown=65):
    """Returns a block from the middle of the line, with ellipsis."""
    shortline = longline.strip()
    if len(shortline) > chars_shown and len(shortline) > chars_trimmed :
        shortline = '...' + shortline[chars_trimmed : chars_trimmed+chars_shown] + '...'
    return shortline


def filecount(path) :
    """Walks path to return file count."""
    return sum(1 for root, dirs, files in os.walk(path) for name in files)

def get_filelist(path=None, *extentions):
    """
    Gets config files in given path. Walks subdirs. Skips dirs named <skipdir>.
    Usage:
    >>> path = 'input/ETL/'
    >>> file_exts = ('.config', '.bat')
    >>> filelist = get_filelist(path, *file_exts)
    >>> print 'Found {} files in path {}, exts={}'.format(len(filelist), path, file_exts) # doctest: +ELLIPSIS
    Found ... files in path input/ETL/, exts=('.config', '.bat')
    """
    skipdir='Backup'
    if not path:
        raise Exception('path is required for get_filelist.')

    filelist = []

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


def change_roots(srcdir, newdir, *inc_exts) :
    """Returns a dict of every file in srcdir matching exts. oldname:newname
    Usage:
    >>> print change_roots('./remote', os.path.join(os.getcwd(), 'work'), '.config', '.bat')

    """
    return dict([(s, change_root(s, srcdir, newdir, ensure=True))
                  for s in get_filelist(srcdir, *inc_exts)])


def change_root(filepath, old_root, new_root='work', ensure=False):
    """Returns the new pathname, switching old_root for new_root dir.
    Usage:
    >>> change_root('./remote/ETL/D2/_log4net.config',  './remote')
    'work/ETL/D2/_log4net.config'
    """

    print 'XXXX {0}, {1}, {2}'.format(old_root, new_root, filepath)

    #print 'DEBUG {0} {1} {2}'.format(old_root, new_root, filepath)
    #if x:
    #    old_root, new_root = re.escape(old_root), re.escape(new_root)

    outfilename = re.sub(old_root, new_root, filepath)
    if ensure :
        ensure_dir(outfilename)
    return outfilename


def clipped_file_list(files, maxlength=5) :
    """ Given a long list of files, prints a few, then ellipsis."""
    clipped_list = []
    for i, file in enumerate(files):
        clipped_list.append(file)
        if i is maxlength:
            clipped_list.append('. . . [clipped] . . .{0} total files.'.format(len(files)))
            break
    return clipped_list


def ensure_dir(f):
    """ Creates the dirs to f if they don't already exist. """
    d = os.path.dirname(f)
    if not os.path.exists(d):
        os.makedirs(d)


def copy_files(pathDict, ask=True):
    """ Copy each source file to targ. """
    #import pdb; pdb.set_trace()
    pp = pprint.PrettyPrinter(indent=4)
    print 'The copying will be FROM:'
    pp.pprint(clipped_file_list(sorted(s for s, t in pathDict.iteritems())))
    print 'copying TO:'
    pp.pprint(clipped_file_list(sorted(t for s, t in pathDict.iteritems())))
    if ask:
        r = raw_input('Proceed? [y]/n ')
        if r.lower() == 'n':
            print 'Ok, stopping.'
            sys.exit(0)
    [ensure_dir(t) for t in pathDict.values()]
    [copy(s, t) for s, t in pathDict.items()]


if __name__ == "__main__":
    """Any of the funcs can be called from the bash shell, for example
       -> ./FileUtils.py "filecount('./temp')"
    """
    import sys
    try:
        func = sys.argv[1]
    except: func = None
    if func:
        try:
            exec 'print %s' % func
        except:
            print "Error: incorrect syntax '%s'" % func
            exec 'print %s.__doc__' % func.split('(')[0]
    else:
        import doctest
        doctest.testmod(verbose=True)
        sys.exit(0)

