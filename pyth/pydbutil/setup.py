#! /usr/bin/python
"""
"""
import sys
import os

DIRS = ['log', 'bak']

[os.mkdir(dir) for dir in DIRS if not os.path.isdir(dir)]
