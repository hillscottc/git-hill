

import clr 
clr.AddReference('System.Data') 
from System.Data.SqlClient import SqlConnection, SqlParameter 
 
conn_string = 'data source=USFSHWSSQL089; initial catalog=RDxReport; trusted_connection=True' 
connection = SqlConnection(conn_string) 
connection.Open() 
command = connection.CreateCommand() 
#command.CommandText = 'select id, name from people where group_id = @group_id' 
#command.Parameters.Add(SqlParameter('group_id', 23)) 
command.CommandText = 'select top 5 * from r2.resource;' 

reader = command.ExecuteReader() 
while reader.Read(): 
    #print reader
    print reader['ISRC']
 
connection.Close() 
