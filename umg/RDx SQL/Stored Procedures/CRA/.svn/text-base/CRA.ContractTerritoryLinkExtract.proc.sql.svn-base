CREATE PROCEDURE [CRA].[ContractTerritoryLinkExtract]
	@FileName NVarchar(500),
	@retVal int = -1 OUTPUT 
AS
BEGIN

TRUNCATE TABLE CRA.LOADCONTRACTTERRITORYLINK;
	
DECLARE @InsertCount integer;
DECLARE @sSQL NVarchar(1000)
SET @sSQL= "
DECLARE @hDoc int
DECLARE @xml xml

set @xml=(select convert(xml,BulkColumn, 2)
From openrowset(Bulk'"+ @FileName + "', single_blob) [rowsetresults]);

exec sp_xml_preparedocument @hDoc OUTPUT, @xml
INSERT INTO CRA.LOADCONTRACTTERRITORYLINK
SELECT *
FROM OPENXML(@hDoc, 'ROWSET/ROW',2)
WITH (TERRITORY_ID VARCHAR(10),
CONTRIBUTOR_ID BIGINT,
GTA_COMPANY_ID VARCHAR(10),
TERRITORY_TYPE VARCHAR(10),
CREATION_DATETIME DATETIME,
MODIFICATION_DATETIME DATETIME)
exec sp_xml_removedocument @hDoc ";

EXEC sp_executesql @sSQL 

set @insertCount = @@rowcount;

set @filename = RIGHT(@FileName, CHARINDEX('\', REVERSE(@FileName))-1);
set @filename = substring(@filename,0,24);

INSERT INTO Admin.DataIngestion (SourceID,RecordsReceived,StartRunDateTime,ProcessStep,Process)
values ('CRA',@insertCount,getdate(),'CRA.LoadContractTerritoryLink',@filename);	

return @@rowcount

END