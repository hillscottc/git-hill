#! /usr/bin/python
"""Manages a set of matches. Mainly provides reporting.

Usage:
"""
import sys
import os
import re
import itertools
from MatchedConfig import MatchedConfig
from DbSet import DbSet
import FileUtils
import pprint
import Configure
from PrintWriter import PrintWriter
import MatchReport
#import pdb; pdb.set_trace()

class MyError(Exception):
    def __init__(self, value):
         self.value = value
    def __str__(self):
         return repr(self.value)

def get_file_app(filename):
    return next((app for app in Configure.APPS if re.search(app, filename, re.IGNORECASE)), None)

def get_files_with_matches(md, matches=True):
    if matches:
        return [k for k, v in md.iteritems() if len(v)]
    else:
        return [k for k, v in md.iteritems() if not len(v)]


def get_all_matches(matchdict):
    """ Returns all the matches in all the lists, flattened. """
    all_lists = [mcList for mcList in matchdict.values()]
    all_matches = [mc for mc in all_lists]
    # flattens. dont want a list of lists.
    return  list(itertools.chain(*all_matches))


def summary(matchdict, config_objs, apps=None, logfilename='ReportSummary.log'):

    if not apps:
        apps = Configure.APPS

    pw = PrintWriter(os.path.join("logs", logfilename))

    pw.write_line(os.linesep)
    pw.write_line('-----SUMMARY-----')

    for app in apps:
        pw.write_line(app)

        appmatches = [mc for mc in get_all_matches(matchdict) if (mc.app is app)]

        if not appmatches :
            pw.write_line('  None for ' + app)
            continue

        for mtype in sorted(config_objs.keys()) :

            hit_count = sum(1 for mc in get_all_matches(matchdict) if (mc.app is app) and (mc.mtype is mtype) and (mc.before == mc.after))
            miss_count = sum(1 for mc in get_all_matches(matchdict) if (mc.app is app) and (mc.mtype is mtype) and (mc.before != mc.after))

            if hit_count:
                pw.write_line('{0:3} {1} references were already properly configured.'.format(hit_count, mtype))
            if miss_count:
                pw.write_line('{0:3} {1} references had suggested changes.'.format(miss_count, mtype))

    pw.write_line(os.linesep)
    pw.write_line("-----FILE SUMMARY-----")

    msg = '{0:3} total matches in {1} files.'
    pw.write_line(msg.format(sum(1 for mc in get_all_matches(matchdict)),
                            len(matchdict.keys())))

    msg = '{0:3} total matches were already properly configured.'
    pw.write_line(msg.format(sum(1 for mc in get_all_matches(matchdict) if mc.before == mc.after)))

    msg = '{0:3} total matches had suggested changes.'
    pw.write_line(msg.format(sum(1 for mc in get_all_matches(matchdict) if mc.before != mc.after)))

    msg = '{0:3} total matches had NO suggestions.'
    pw.write_line(msg.format(len([mc for mc in get_all_matches(matchdict) if not mc.after])))


def details(matchdict, apps=None, logfilename='ReportDetails.log'):
    
    if not apps:
        apps = Configure.APPS
    
    pw = PrintWriter(os.path.join("logs", logfilename))
    pw.write_line(os.linesep)
    for app in apps:
        pw.write_line("-----DETAILS for '{0}'-----".format(app))

        appfiles = [filename for filename in matchdict.keys() if get_file_app(filename) == app]

        if not appfiles :
            pw.write_line('   None for ' + app)
            continue

        for filename in appfiles :

            pw.write_line('FILE: ' + filename)
            for mc in matchdict[filename]:
                if mc.app is app:
                    if mc.mtype == 'DB':
                    #if isinstance(mc, mctchConn):
                        pw.write('    line {0}, {1} is pointed to {2}'.format(
                                 mc.linenum, mc.before.dbname, mc.before.boxname))
                        if mc.after == mc.before:
                            pw.write_line('...OK...no change.')
                        elif mc.after:
                            pw.write_line('...needs change to {0}'.format(mc.after.boxname))
                        else:
                            pw.write_line('...no suggestions.')
                    elif mc.mtype in ('LOG_A', 'LOG_B') :
                        pw.write('    line {0}, LOGFILE is at {1}'.format(mc.linenum, mc.before))
                        if mc.after == mc.before:
                            pw.write_line('...OK...no change.')
                        elif mc.after:
                            pw.write_line('...needs change to {0}'.format(mc.after) )
                        else:
                            pw.write_line('...no suggestions.')
                    elif mc.mtype == 'FTP' :
                        pw.write('    line {0}, {1} points to {2}'.format(
                             mc.linenum, mc.newname, mc.before))
                        if mc.after == mc.before:
                            pw.write_line('...OK...no change.')
                        elif mc.after:
                            pw.write_line('...needs change to {0}'.format(mc.after))
                        else:
                            pw.write_line('...no suggestions.')
                    elif mc.mtype in ('SMTP', 'TO_VAL', 'FROM_VAL', 'SUBJ') :
                        pw.write('    line {0}, {1} is {2}'.format(mc.linenum, mc.mtype, mc.before))
                        if mc.after == mc.before:
                            pw.write_line('...OK...no change.')
                        elif mc.after:
                            pw.write_line('...needs change to {0}'.format(mc.after))
                        else:
                            pw.write_line('...no suggestions.')
                    else :
                        raise Exception('no match for mc.mtype', mc.mtype)



if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    sys.exit(0)

