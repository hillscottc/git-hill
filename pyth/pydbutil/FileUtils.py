#! /usr/bin/python
""" Some static file methods.

Usage: Any of the funcs can be called from the bash shell. (See main.)

-> ./FileUtils.py "backup('./temp')"

 """
import os
import re
import sys
import time
import subprocess
import pprint
import logging
from shutil import copy, copy2, copystat, rmtree, ignore_patterns

class Error(Exception):
    def __init__(self, msg):
        self.msg = msg

def get_work_path(path, old_dir, new_dir='work'):
    """Usage:
    >>> get_work_path('./remote/ETL/D2/_log4net.config',  './remote')
    'work/ETL/D2/_log4net.config'
    """
    return re.sub(old_dir, new_dir, path)


# def get_logname(configs, app):
#     # logpath = configs['LOG_A'].changeval + "\\" + app
#     # return logpath + "\\" + app + '_etl.txt'
#     return os.path.join(configs['LOG_A'].changeval, app, app + '_etl.txt')


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


def trim_line(longline, max_length=80, chars_trimmed=20, chars_shown=65):
    """Returns a block from the middle of the line, with ellipsis."""
    shortline = longline.strip()
    if len(shortline) > chars_shown and len(shortline) > chars_trimmed :
        shortline = '...' + shortline[chars_trimmed : chars_trimmed+chars_shown] + '...'
    return shortline


def filecount(path) :
    """Walks path to return file count."""
    return sum(1 for root, dirs, files in os.walk(path) for name in files)






def walk_wrap(src=None, dst=None, symlinks=False, action=None, *extentions):
    """ I modified the 2.7 implementation of shutils.copytree
    to take a list of extentions to INCLUDE, instead of an ignore list.
    Then, I pass a function as an action for each found item.
    """
    names = os.listdir(src)
    os.makedirs(dst)
    errors = []
    for name in names:
        srcname = os.path.join(src, name)
        dstname = os.path.join(dst, name)
        try:
            if symlinks and os.path.islink(srcname):
                linkto = os.readlink(srcname)
                os.symlink(linkto, dstname)
            elif os.path.isdir(srcname):
                #my_copytree(srcname, dstname, symlinks, *extentions)
                walk_wrap(srcname, dstname, symlinks, action, *extentions)
            else:
                ext = os.path.splitext(srcname)[1]
                if not ext in extentions:
                    # skip the file
                    continue
                #copy2(srcname, dstname)
                action(srcname, dstname)
            # XXX What about devices, sockets etc.?
        except (IOError, os.error), why:
            errors.append((srcname, dstname, str(why)))
        # catch the Error from the recursive copytree so that we can
        # continue with other files
        except Error, err:
            errors.extend(err.args[0])
    try:
        copystat(src, dst)
    # except WindowsError: # cant copy file access times on Windows
    #     pass
    except OSError, why:
        errors.extend((src, dst, str(why)))
    if errors:
        raise Error(errors)


def get_backupdir(src=None, dst=None, timestamped=False) :

    # path like ./temp
    if os.path.basename(src) and os.path.isdir(src):
        src = os.path.basename(src)
    # path like ./temp/
    elif not os.path.basename(src) and os.path.isdir(src):
        src = os.path.basename(os.path.dirname(src))
    else:
        raise Exception('Must supply a valid directory. You said:', src)

    if not dst:
        dst = os.getcwd()
    dst = os.path.join(dst, 'bak', src)

    if timestamped :
        dst = os.path.join(dst, time.strftime('%m%d%H%M%S'))

    return dst

def backup(src=None, dst=None, *extentions):
    """ Backup files with matching extentions from src dir to dst.
    Usage:
    >>> backup('./temp')                                   # doctest: +ELLIPSIS
    Backed up ... files from ./temp to ./bak/temp
    >>> exts = ('.config', '.bat')
    >>> backup('./temp', os.getcwd(), '.config', '.bat')                # doctest: +ELLIPSIS
    Backed up ... files from ./temp to ./bak/temp
    """
    #import pdb; pdb.set_trace()

    if not extentions:
        extentions = ('.config', '.bat')

    if not dst :
        dst = os.getcwd()

    dst = get_backupdir(src, dst)

    if os.path.exists(dst) :
        if not os.path.samefile(dst, os.getcwd()) :
            rmtree(dst)

    # define a function to use shutil.copy2
    def action(x, y): copy2(x, y)

    walk_wrap(src, dst, False, action, *extentions)

    msg = 'Backed up {0} files from {1} to {2}'
    print msg.format(filecount(dst), src, dst)


def clipped_file_list(files, maxlength=5) :
    """ Given a long list of files, prints a few, then ellipsis."""
    clipped_list = []
    for i, file in enumerate(files):
        clipped_list.append(file)
        if i is maxlength:
            clipped_list.append('. . . [clipped] . . .{0} total files.'.format(len(files)))
            break
    return clipped_list


def get_outfilename(before, after, infilename):
    """ Returns path to ./outdir/filename. Creates if necc.
    Usage:
    >>> print get_outfilename('remote', 'work', 'remote/etl/carl/somefile.txt')
    work/etl/carl/somefile.txt
    """
    outfilename = re.sub(before, after, infilename)
    ensure_dir(outfilename)
    return outfilename


def ensure_dir(f):
    """ Creates the dirs to f if they don't already exist. """
    d = os.path.dirname(f)
    if not os.path.exists(d):
        os.makedirs(d)


def copy_files(sourcepaths, targpaths, ask=True):
    """ Copy each source file to targ. """
    #import pdb; pdb.set_trace()
    pp = pprint.PrettyPrinter(indent=4)
    print 'The copying will be FROM:'
    pp.pprint(clipped_file_list(sourcepaths))
    print 'copying TO:'
    pp.pprint(clipped_file_list(targpaths))
    if ask:
        r = raw_input('Proceed? [y]/n ')
        if r.lower() == 'n':
            print 'Ok, stopping.'
            sys.exit(0)
    [ensure_dir(f) for f in targpaths]
    map(copy, sourcepaths, targpaths)


if __name__ == "__main__":
    """Any of the funcs can be called from the bash shell, for example
       -> ./FileUtils.py "backup('./temp')"
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

