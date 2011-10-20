
"""

Usage: ipy run_sql.py -p sql_test.sql -d RDxReport -b USFSHWSSQL089

Args:
    -p: targ file or dir
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
    return 'data source={%s};initial catalog={%s}; trusted_connection=True'.format(boxname, dbname)


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
        print 'Record %s' % i

        for i in range(reader.FieldCount) :
            print '{:>30}: {}'.format(reader.GetName(i), reader.GetValue(i))
     
    connection.Close()  
    print 'Closed connnection', conn_str

def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(argv[1:], "hp:d:b:w"\
                , ["help", "path=", "dbame=", "boxname=", "write"])
        except getopt.error, msg:
            raise Usage(msg)

        path = None
        dbname = None
        boxname = None
        write = False
        
        for opt, arg in opts :
            if opt in ("-h", "--help") :
                print __doc__
                sys.exit(0)
            elif opt in ("-p", "--path") :
                path = arg
            elif opt in ("-d", "--dbname") :
                dbname = arg    
            elif opt in ("-b", "--boxname") :
                boxname = arg
            elif opt in ("-w", "--write") :
                write = True  
                

        if not path :
            raise Usage('')

        if not dbname :
            raise Usage('')

        if not boxname :
            raise Usage('')

        if not os.path.isfile(path) :
            raise Usage("'$' is not a valid file.".format(path))

        #sp_text = 'select top 5 * from r2.resource;' 
        sp_text = get_text(path)
        conn_str = get_conn_str(boxname, dbname)        
            
        exe_SqlReader(sp_text, conn_str)
        print "Complete."
        print
		
    except Usage, err :
        print >>sys.stderr, "Sorry, invalid options. For help, use --help"
        print >>sys.stderr, "Other errors:", err.msg
        return 2


if __name__ == "__main__":
    sys.exit(main())

 
 
 

 
