CREATE PROCEDURE [CRL].[ExceptionAssetExtract]
	@FileName NVarchar(500),
	@retVal int = -1 OUTPUT 
AS
BEGIN

TRUNCATE TABLE CRL.LoadExceptionAsset;

DECLARE @ReceiveCount integer;
DECLARE @sSQL NVarchar(1000)
SET @sSQL= "
DECLARE @hDoc int
DECLARE @xml xml

set @xml=(select convert(xml,BulkColumn, 2)
From openrowset(Bulk'"+ @FileName + "', single_blob) [rowsetresults]);

exec sp_xml_preparedocument @hDoc OUTPUT, @xml
INSERT INTO CRL.LoadExceptionAsset
SELECT *
FROM OPENXML(@hDoc, 'ROWSET/ROW',2)
WITH (
EXCEPTION_ASSET_ID NUMERIC(38,0),
FK_EXCEPTION_ID NUMERIC(38,0),
FK_RMS_ASSET_ID NUMERIC(38,0),
STATUS NCHAR(1),
DATE_REMOVED DATETIME,
OBJ_VER Int,
PROCESSED_IND NCHAR(1)
)
exec sp_xml_removedocument @hDoc ";

EXEC sp_executesql @sSQL 
set @ReceiveCount = @@rowcount;

set @filename = RIGHT(@FileName, CHARINDEX('\', REVERSE(@FileName))-1);
set @filename = substring(@filename,0,24);

INSERT INTO Admin.DataIngestion (SourceID,RecordsReceived,StartRunDateTime,ProcessStep,Process)
values ('CARL',@ReceiveCount,getdate(),'CRL.LoadExceptionAsset',@filename);
	
return @@rowcount

END