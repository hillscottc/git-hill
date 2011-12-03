#! /usr/bin/python

import re
import os
from DbSet import DbSet


def ensure_dir(f):
    d = os.path.dirname(f)
    if not os.path.exists(d):
        os.makedirs(d)
        

ensure_dir('temp/test/test.txt')

