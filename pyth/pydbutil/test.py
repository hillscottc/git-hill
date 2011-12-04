#! /usr/bin/python

import re
import os
from ConnMatchInfo import ConnMatchInfo
from MatchSet import MatchSet

cmi1 = (ConnMatchInfo('Usfshwssql104', 'RDxETL', 5),
        ConnMatchInfo('Usfshwssql104', 'RDxReport', 10))



ms = MatchSet(file1=cmi1)

print ms

print ['{} {}'.format(k, v) for k, v in ms.matches.iteritems()]

cmi2 = (ConnMatchInfo('Usfshwssql99', 'RDxETL', 5),
        ConnMatchInfo('Usfshwssql99', 'RDxReport', 10))

md = dict(file1=cmi1, file2=cmi2)

ms = MatchSet(**md)


print ms

print ['{} {}'.format(k, v) for k, v in ms.matches.iteritems()]


