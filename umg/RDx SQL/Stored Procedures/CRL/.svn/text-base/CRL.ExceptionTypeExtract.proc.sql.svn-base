CREATE PROCEDURE [CRL].[ExceptionTypeExtract]
	@FileName NVarchar(500),
	@retVal int = -1 OUTPUT 
AS
BEGIN

TRUNCATE TABLE CRL.LoadExceptionType;

DECLARE @ReceiveCount integer;
DECLARE @sSQL NVarchar(1000)
SET @sSQL= "
DECLARE @hDoc int
DECLARE @xml xml

set @xml=(select convert(xml,BulkColumn, 2)
From openrowset(Bulk'"+ @FileName + "', single_blob) [rowsetresults]);

exec sp_xml_preparedocument @hDoc OUTPUT, @xml
INSERT INTO CRL.LoadExceptionType
SELECT *
FROM OPENXML(@hDoc, 'ROWSET/ROW',2)
WITH (
EXCEPTION_TYPE_ID NUMERIC(38,0),
ALPHA_CODE NCHAR(1),
STATUS NCHAR(1),
OBJ_VER Int
)
exec sp_xml_removedocument @hDoc ";

EXEC sp_executesql @sSQL 
set @ReceiveCount = @@rowcount;

set @filename = RIGHT(@FileName, CHARINDEX('\', REVERSE(@FileName))-1);
set @filename = substring(@filename,0,24);

INSERT INTO Admin.DataIngestion (SourceID,RecordsReceived,StartRunDateTime,ProcessStep,Process)
values ('CARL',@ReceiveCount,getdate(),'CRL.LoadExceptionType',@filename);
	
return @@rowcount

END