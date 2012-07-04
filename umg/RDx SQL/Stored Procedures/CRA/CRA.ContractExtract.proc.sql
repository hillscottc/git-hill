CREATE PROCEDURE [CRA].[ContractExtract]
	@FileName NVarchar(500),
	@retVal int = -1 OUTPUT 
AS
BEGIN

TRUNCATE TABLE CRA.LoadContract;

DECLARE @insertCount integer;
DECLARE @sSQL NVarchar(1000)
SET @sSQL= "
DECLARE @hDoc int
DECLARE @xml xml

set @xml=(select convert(xml,BulkColumn, 2)
From openrowset(Bulk'"+ @FileName + "', single_blob) [rowsetresults]);

exec sp_xml_preparedocument @hDoc OUTPUT, @xml
INSERT INTO CRA.LoadContract
SELECT *
FROM OPENXML(@hDoc, 'ROWSET/ROW',2)
WITH (CONTRIBUTOR_ID BIGINT,
CRCO_START_DATE DATETIME,
CRCO_END_DATE DATETIME,
CRCO_COMMENTS NTEXT,
GTA_COMPANY_ID_1 NVARCHAR(10),
GTA_COMPANY_ID_2 NVARCHAR(10),
CRCO_MASTER_IND CHAR(1),
CRCO_NO_RIGHTS_IND CHAR(1),
CRCO_UPDATED_DATE DATETIME,
CRCO_MULTI_ARTIST_IND CHAR(1),
CRCO_CREATION_DATE DATETIME,
CRCO_CREATED_BY_CONTACT NVARCHAR(50),
CRCO_EXP_DATE DATETIME
)
exec sp_xml_removedocument @hDoc ";

EXEC sp_executesql @sSQL 

set @insertCount = @@rowcount;

set @filename = RIGHT(@FileName, CHARINDEX('\', REVERSE(@FileName))-1);
set @filename = substring(@filename,0,24);

INSERT INTO Admin.DataIngestion (SourceID,RecordsReceived,StartRunDateTime,ProcessStep,Process)
values ('CRA',@insertCount,getdate(),'CRA.LoadContract',@filename);
	
return @@rowcount

END