CREATE PROCEDURE [CRA].[ArticleContractExtract]
	@FileName NVarchar(500),
	@retVal int = -1 OUTPUT 
AS
BEGIN

TRUNCATE TABLE CRA.LoadArticleContract;

DECLARE @insertCount integer;
DECLARE @sSQL NVarchar(1000)
SET @sSQL= "
DECLARE @hDoc int
DECLARE @xml xml

set @xml=(select convert(xml,BulkColumn, 2)
From openrowset(Bulk'"+ @FileName + "', single_blob) [rowsetresults]);

exec sp_xml_preparedocument @hDoc OUTPUT, @xml
INSERT INTO CRA.LoadArticleContract
SELECT *
FROM OPENXML(@hDoc, 'ROWSET/ROW',2)
WITH (CRAR_ID BIGINT,
GTA_COMPANY_ID NVARCHAR(10),
CONTRIBUTOR_ID BIGINT,
CREATION_DATETIME DATETIME,
NO_RIGHTS_IND CHAR(1),
RMS_ID NVARCHAR(20),
PPC NVARCHAR(20)
)
exec sp_xml_removedocument @hDoc ";

EXEC sp_executesql @sSQL 
set @insertCount = @@rowcount;

set @filename = RIGHT(@FileName, CHARINDEX('\', REVERSE(@FileName))-1);
set @filename = substring(@filename,0,24);

INSERT INTO Admin.DataIngestion (SourceID,RecordsReceived,StartRunDateTime,ProcessStep,Process)
values ('CRA',@insertCount,getdate(),'CRA.LoadArticleContract',@filename);
	
return @@rowcount

END