#! /usr/bin/python

import re
import os
from DbSet import DbSet


regexs = ('Data Source=(Usfshwssql\w+);Initial Catalog=(RDx\w+);',
          'Data Source=([\w\\\]+);Initial Catalog=(RDx\w+);')

#regexs = ['Data Source=(Usfshwssql\w+);Initial Catalog=(RDx\w+);']


lines = ('<add name="RDxReportConnectionString" connectionString="Data Source=USFSHWSSQL104\RIGHTSDEV_2;Initial Catalog=RDxReport;Integrated Security=True"',
         '<add name="RDxReportConnectionString" connectionString="Data Source=USFSHWSSQL104;Initial Catalog=RDxReport;Integrated Security=True"')
         
def s(regex, line):
    return re.search(regex, line, re.IGNORECASE)


for line in lines :         
    print [[group for group in s(regex, line).groups()] for regex in regexs if s(regex, line)]

