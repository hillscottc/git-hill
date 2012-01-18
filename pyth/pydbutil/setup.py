#! /usr/bin/python
"""
"""
import sys
import os

DIRS = ['logs', 'bak']

[os.mkdir(dir) for dir in DIRS if not os.path.isdir(dir)]
