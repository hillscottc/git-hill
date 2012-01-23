#! /usr/bin/python
"""Manages a set of matches.

Usage:
"""
import sys
import os
import itertools
from MatchedConfig import MatchedConfig
import FileUtils
import pprint
#from clint.textui import puts, colored, indent



class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

class MatchSet(object):
    """
    Manages a set of matches.
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
        all_lists = [mcList for mcList in self.matches.values()]
        all_matches = [mc for mc in all_lists]
        # flattens. dont want a list of lists.
        return  list(itertools.chain(*all_matches))


    def get_files_with_matches(self, matches=True):
        if matches:
            return [k for k, v in self.matches.iteritems() if len(v)]
        else:
            return [k for k, v in self.matches.iteritems() if not len(v)]


    def get_work_files(self, workdir, outdir):
        outfilenames = []
        #import pdb; pdb.set_trace()
        for filename in self.matches.keys() :
            for mc in self.matches[filename]:
                if mc.after:
                    outfilenames.append(FileUtils.get_outfilename(workdir, outdir, filename))
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




    def summary_matches(self, config_objs):

        lines = []
        lines.append('')
        msg = '{0:3} total matches in {1} files.'
        lines.append(msg.format(sum([len(v) for v in self.matches.values()]),
                                len(self.get_files_processed())))

        msg = '{0:3} DB connections were already properly configured.'
        lines.append(msg.format(len([mc for mc in self.get_all_matches()
                                     if (mc.mtype is 'DB') and (mc.before == mc.after)])))

        msg = '{0:3} DB connections had suggested changes.'
        lines.append(msg.format(len([mc for mc in self.get_all_matches()
                                     if (mc.mtype is 'DB') and (mc.before != mc.after)])))

        msg = '{0:3} FTP filepath references were already properly configured.'
        lines.append(msg.format(len([mc for mc in self.get_all_matches()
                                     if (mc.mtype is 'FTP') and (mc.before == mc.after)])))
        msg = '{0:3} FTP filepath references had suggested changes.'
        lines.append(msg.format(len([mc for mc in self.get_all_matches()
                                     if (mc.mtype is 'FTP') and (mc.before != mc.after)])))

        msg = '{0:3} LOG file references were already properly configured.'
        lines.append(msg.format(len([mc for mc in self.get_all_matches()
                                     if mc.mtype in ('LOG_A', 'LOG_B')
                                     and mc.before == mc.after])))
        msg = '{0:3} LOG file references had suggested changes.'
        lines.append(msg.format(len([mc for mc in self.get_all_matches()
                                     if mc.mtype in ('LOG_A', 'LOG_B')
                                     and mc.before != mc.after])))
        lines.append('ORRRRRRRR')


        for mtype in sorted(config_objs.keys()) :

            hit_count = sum(1 for mc in self.get_all_matches() if (mc.mtype is mtype) and (mc.before == mc.after))
            miss_count = sum(1 for mc in self.get_all_matches() if (mc.mtype is mtype) and (mc.before != mc.after))

            lines.append('{0:3} {1} references were already properly configured.'.format(hit_count, mtype))
            lines.append('{0:3} {1} references had suggested changes.'.format(miss_count, mtype))

        lines.append('')

        msg = '{0:3} total matches in {1} files.'
        lines.append(msg.format(sum([len(v) for v in self.matches.values()]),
                                len(self.get_files_processed())))

        msg = '{0:3} total matches were already properly configured.'
        lines.append(msg.format(sum(1 for mc in self.get_all_matches() if mc.before == mc.after)))

        msg = '{0:3} total matches had suggested changes.'
        lines.append(msg.format(sum(1 for mc in self.get_all_matches() if mc.before != mc.after)))

        msg = '{0:3} total matches had NO suggestions.'
        lines.append(msg.format(len([mc for mc in self.get_all_matches() if not mc.after])))



        return os.linesep.join(lines)



    def summary_details(self):

        lines = []

        for filename in self.matches.keys() :
            lines.append('FILE: ' + filename)
            for mc in self.matches[filename]:
                if mc.mtype is 'DB':
                #if isinstance(mc, mctchConn):
                    l = '  line {0}, {1} is pointed to {2}'.format(mc.linenum,
                                            mc.before.dbname, mc.before.boxname)
                    if mc.after == mc.before:
                        l += '...OK...no change.'
                    elif mc.after:
                        l += '...changing to {0}'.format(mc.after.boxname)
                    else:
                        l +=  '...no suggestions...no change.'
                    lines.append(l)
                elif mc.mtype in ('LOG_A', 'LOG_B') :
                    l = '  line {0}, LOGFILE is at {1}'.format(mc.linenum, mc.before)
                    if mc.after == mc.before:
                        l += '...OK...no change.'
                    elif mc.after:
                        l += os.linesep + '   ...changing to {0}'.format(mc.after)
                    else:
                        l +=  '...no suggestions...no change.'
                    lines.append(l)
                elif mc.mtype is 'FTP' :
                    l = '  line {0}, {1} points to {2}'.format(
                         mc.linenum, mc.newname, mc.before)
                    if mc.after == mc.before:
                        l += '...OK...no change.'
                    elif mc.after:
                        l += '...changing to {0}'.format(mc.after)
                    else:
                        l +=  '...no suggestions...no change.'
                    lines.append(l)
                elif mc.mtype in ('SMTP', 'TO_VAL', 'FROM_VAL', 'SUBJ') :
                    l = '  line {0}, {1} is {2}'.format(mc.linenum, mc.mtype, mc.before)
                    if mc.after == mc.before:
                        l += '...OK...no change.'
                    elif mc.after:
                        l += os.linesep + '   ...changing to {0}'.format(mc.after)
                    else:
                        l +=  '...no suggestions...no change.'
                    lines.append(l)

        return os.linesep.join(lines)




if __name__ == "__main__":
    import doctest
    doctest.testmod(verbose=True)
    sys.exit(0)

