#! /usr/bin/python

import os

def get_new_filename(*filename):
    """ Given filename config.txt, returns config.new.txt"""
    
    head, tail = os.path.split(filename)
    root, ext = os.path.splitext(tail)
    print head, tail, root, ext

filenames=[]
filename = "config-mgr.py"
filename = filename, "scrap.py"
get_new_filename(filename)

    
    #print '"%s" : "%s"' % (path, os.path.split(path))







