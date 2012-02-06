

def get_bak_dir(source, targ='.', timestamped=False) :
    """ Gets name of backup dir for soourcedir. With timestamping option.
    Usage:
    >>> sources = ['./remote', './remote/']
    >>> print [get_bak_dir(source=path, timestamped=True) for path in sources] # doctest: +ELLIPSIS
    ['./bak/.../remote', './bak/.../remote']
    >>> print [get_bak_dir(path) for path in sources]
    ['./bak/remote', './bak/remote']
    >>> print [get_bak_dir(path, './temp/', False) for path in sources]
    ['./temp/bak/remote', './temp/bak/remote']
    """

    if not os.path.isdir(source):
        raise Exception('Must supply a valid dir. Bad path:', source)

    if targ and targ != '.':
        ensure_dir(targ)

    if timestamped :
        t = time.strftime('%m%d%H%M%S')
        return os.path.join(targ, 'bak', t, os.path.relpath(source))
    else :
        return os.path.join(targ, 'bak', os.path.relpath(source))


def backup(source, timestamped=False):
    """ Backup source dir to targ, skipping indicated dirs.
    Usage:
    >>> s = './temp'
    >>> backup(s)
    Backed up ./temp to ./bak/temp
    >>> backup(s, timestamped=True) # doctest: +ELLIPSIS
    Backed up ./temp to ./bak/.../temp
    """
    targ = get_bak_dir(source, targ=targ, timestamped=timestamped)
    if not timestamped and os.path.exists(targ) :
        rmtree(targ)
    copytree(source, targ, ignore=ignore_patterns(
             '*.pyc', 'tmp*','Backup*', '.git', '.svn'))
    print 'Backed up', source, 'to', targ