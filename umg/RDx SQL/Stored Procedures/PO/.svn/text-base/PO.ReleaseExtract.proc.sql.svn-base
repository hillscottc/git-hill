CREATE PROCEDURE [PO].[ReleaseExtract]
@FileName NVARCHAR (500), @retVal INT=-1 OUTPUT
AS
BEGIN

TRUNCATE TABLE PO.LoadRelease;

DECLARE @receivedCount integer;
DECLARE @sSQL NVarchar(1000)
SET @sSQL= "
DECLARE @hDoc int
DECLARE @xml xml

set @xml=(select convert(xml,BulkColumn, 2)
From openrowset(Bulk'"+ @FileName + "', single_blob) [rowsetresults]);

exec sp_xml_preparedocument @hDoc OUTPUT, @xml
INSERT INTO PO.LoadRelease
SELECT *
FROM OPENXML(@hDoc, 'PartsOrderRdx/Table',2)
WITH (UPC nvarchar(50),
RELEASE_DATE nvarchar(50),
RELEASE_RIGHTS nvarchar(300)
)
exec sp_xml_removedocument @hDoc ";

EXEC sp_executesql @sSQL 

set @receivedCount = @@rowcount;
set @filename = RIGHT(@FileName, CHARINDEX('\', REVERSE(@FileName))-1);

INSERT INTO Admin.DataIngestion (SourceID,RecordsReceived,StartRunDateTime,ProcessStep,Process)
values ('PO',@receivedCount,getdate(),'PO.LoadRelease',@filename);	
	
return @@rowcount

END
