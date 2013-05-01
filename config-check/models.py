

class Site(object):
    def __init__(self, id, name, host, cmd=None):
        self.id = id
        self.name = name
        self.host = host
        self.cmd = cmd
