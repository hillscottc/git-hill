#! /usr/bin/python
"""Manages a set of matches. Mainly provides reporting.

Usage:
"""
import sys
import os
import itertools
from MatchedConfig import MatchedConfig
from DbSet import DbSet
import FileUtils
import pprint
import Configure
#from clint.textui import puts, colored, indent
#import pdb; pdb.set_trace()

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg


def get_files_with_matches(md, matches=True):
    if matches:
        return [k for k, v in md.iteritems() if len(v)]
    else:
        return [k for k, v in md.iteritems() if not len(v)]


def get_work_files(md, workdir, outdir):
    outfilenames = []

    for filename in md.keys() :
        for mc in md[filename]:
            if mc.after:
                outfilenames.append(FileUtils.change_root(filename, workdir, outdir))
            break
    return outfilenames


def get_all_matches(matchdict):
    """ Returns all the matches in all the lists, flattened. """
    all_lists = [mcList for mcList in matchdict.values()]
    all_matches = [mc for mc in all_lists]
    # flattens. dont want a list of lists.
    return  list(itertools.chain(*all_matches))


def matches(matchdict, config_objs, apps=None):

    if not apps:
        apps = Configure.APPS

    lines = []
    lines.append('')

    for app in apps:
        lines.append('APP: ' + app)
        for mtype in sorted(config_objs.keys()) :

            hit_count = sum(1 for mc in get_all_matches(matchdict) if (mc.app is app) and (mc.mtype is mtype) and (mc.before == mc.after))
            miss_count = sum(1 for mc in get_all_matches(matchdict) if (mc.app is app) and (mc.mtype is mtype) and (mc.before != mc.after))

            if hit_count:
                lines.append('{0:3} {1} references were already properly configured.'.format(hit_count, mtype))
            if miss_count:
                lines.append('{0:3} {1} references had suggested changes.'.format(miss_count, mtype))

    lines.append('')

    msg = '{0:3} total matches in {1} files.'
    lines.append(msg.format(sum(1 for mc in get_all_matches(matchdict)),
                            len(matchdict.keys())))

    msg = '{0:3} total matches were already properly configured.'
    lines.append(msg.format(sum(1 for mc in get_all_matches(matchdict) if mc.before == mc.after)))

    msg = '{0:3} total matches had suggested changes.'
    lines.append(msg.format(sum(1 for mc in get_all_matches(matchdict) if mc.before != mc.after)))

    msg = '{0:3} total matches had NO suggestions.'
    lines.append(msg.format(len([mc for mc in get_all_matches(matchdict) if not mc.after])))


    return os.linesep.join(lines)


def details(matchdict, apps=None):

    if not apps:
        apps = Configure.APPS

    lines = []
    print
    for app in apps:
        lines.append('REPORT APP: ' + app)

        for filename in matchdict.keys() :

            lines.append('  ' + filename)
            for mc in matchdict[filename]:
                if mc.app is app:
                    if mc.mtype is 'DB':
                    #if isinstance(mc, mctchConn):
                        l = '    line {0}, {1} is pointed to {2}'.format(mc.linenum,
                                                mc.before.dbname, mc.before.boxname)
                        if mc.after == mc.before:
                            l += '...OK...no change.'
                        elif mc.after:
                            l += '    ...changing to {0}'.format(mc.after.boxname)
                        else:
                            l +=  '...no suggestions...no change.'
                        lines.append(l)
                    elif mc.mtype in ('LOG_A', 'LOG_B') :
                        l = '    line {0}, LOGFILE is at {1}'.format(mc.linenum, mc.before)
                        if mc.after == mc.before:
                            l += '...OK...no change.'
                        elif mc.after:
                            l += os.linesep + '    ...changing to {0}'.format(mc.after)
                        else:
                            l +=  '...no suggestions...no change.'
                        lines.append(l)
                    elif mc.mtype is 'FTP' :
                        l = '    line {0}, {1} points to {2}'.format(
                             mc.linenum, mc.newname, mc.before)
                        if mc.after == mc.before:
                            l += '...OK...no change.'
                        elif mc.after:
                            l += '    ...changing to {0}'.format(mc.after)
                        else:
                            l +=  '...no suggestions...no change.'
                        lines.append(l)
                    elif mc.mtype in ('SMTP', 'TO_VAL', 'FROM_VAL', 'SUBJ') :
                        l = '    line {0}, {1} is {2}'.format(mc.linenum, mc.mtype, mc.before)
                        if mc.after == mc.before:
                            l += '...OK...no change.'
                        elif mc.after:
                            l += os.linesep + '    ...changing to {0}'.format(mc.after)
                        else:
                            l +=  '...no suggestions...no change.'
                        lines.append(l)

    return os.linesep.join(lines)

def summary_files(matchdict):

    lines = []

    lines.append('{0:3} .config files found.'.format
                 (len(matchdict.keys())))

    lines.append('{0:3} files with NO matches.'.format
                 (len(get_files_with_matches(False))))

    lines.append('{0:3} files with at least one match.'.format
                 (len(get_files_with_matches())))

    return os.linesep.join(lines)


if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    sys.exit(0)

