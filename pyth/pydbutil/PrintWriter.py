#! /usr/bin/python
import sys
import os
class PrintWriter(object):
    """ To write and print to a file at the same time."""
    def __init__(self, filename):
        self.terminal = sys.stdout
        self.log = open(filename, "w")
        
    def write(self, message):
        self.terminal.write(message)
        self.log.write(message)

    def write_line(self, message):
        self.terminal.write(message + os.linesep)
        self.log.write(message + os.linesep)