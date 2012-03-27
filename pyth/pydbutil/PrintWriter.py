#! /usr/bin/python
import sys
import os
class PrintWriter(object):
    """ To write and print to a file at the same time."""
    def __init__(self, filename):
        self.terminal = sys.stdout
        self.log = open(filename, "a")
        
    def write(self, message):
        self.terminal.write('{0}{1}'.format(message, os.linesep))
        self.log.write(message)
