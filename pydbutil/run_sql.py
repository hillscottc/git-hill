
"""

Usage: ipy run_sql.py -s "select top 5 * from r2.resource;" -d RDxReport -b USFSHWSSQL089
       ipy run_sql.py -i ./sql_test.sql -d RDxReport -b USFSHWSSQL089
       
       ** Must choose EITHER -s OR -i, not both. **

Args:
    -s: a string of sql
    -i: input sql file
    -d: dbname
    -b: boxname
    -w: writes output file 
Returns:
Raises:
"""

import os
import sys
import getopt
import clr 
clr.AddReference('System.Data') 
from System.Data.SqlClient import SqlConnection, SqlParameter 

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

def get_text(filename) :
    sp_text = ''
    with open(filename, 'r') as file:
        sp_text = file.read()
    return sp_text

def get_conn_str(boxname='USFSHWSSQL089', dbname='RDxReport') :
    return 'data source={};initial catalog={}; trusted_connection=True'.format(boxname, dbname)


def exe_SqlReader(sp_text='select top 5 * from r2.resource;'
, conn_str='data source=USFSHWSSQL089;initial catalog=RDxReport; trusted_connection=True') :

    print 'Opening connnection', conn_str
    connection = SqlConnection(conn_str) 
    connection.Open() 
    command = connection.CreateCommand() 
    command.CommandText = sp_text 

    i = 0
    reader = command.ExecuteReader() 
    while reader.Read(): 
        #print reader
        #print reader.FieldCount
        i = i + 1
        print 'Record {}'.format(i)

        for i in range(reader.FieldCount) :
            print '{:>30}: {}'.format(reader.GetName(i), reader.GetValue(i))

    connection.Close()  
    print 'Closed connnection', conn_str

def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(argv[1:], "hs:i:d:b:w"\
                , ["help", "sql=", "infile=", "dbname=", "boxname=", "write"])
        except getopt.error, msg:
            raise Usage(msg)

        sql = None
        infile = None
        dbname = None
        boxname = None
        write = False

        for opt, arg in opts :
            if opt in ("-h", "--help") :
                print __doc__
                sys.exit(0)
            elif opt in ("-s", "--sql") :
                sql = arg
            elif opt in ("-i", "--infile") :
                infile = arg
            elif opt in ("-d", "--dbname") :
                dbname = arg    
            elif opt in ("-b", "--boxname") :
                boxname = arg
            elif opt in ("-w", "--write") :
                write = True  

        sql_text = None

        if not sql and not infile :
            raise Usage('')
        elif sql and infile :
            raise Usage('')
        elif sql :
            sql_text = sql
        elif infile :
            if os.path.isfile(infile) :
                sql_text = get_text(infile)
            else :
                raise Usage("'{}' is not a valid file.".format(infile))

        if not dbname :
            raise Usage('')

        if not boxname :
            raise Usage('')

        exe_SqlReader(sql_text, get_conn_str(boxname, dbname))

        print "Complete."
        print

    except Usage, err :
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:", err.msg
        return 2


if __name__ == "__main__":
    sys.exit(main())
