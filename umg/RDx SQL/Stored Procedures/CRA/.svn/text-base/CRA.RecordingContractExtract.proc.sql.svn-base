CREATE PROCEDURE [CRA].[RecordingContractExtract]
	@FileName NVarchar(500),
	@retVal int = -1 OUTPUT 
AS
BEGIN

TRUNCATE TABLE CRA.LOADRECORDINGCONTRACT;

DECLARE @insertCount integer;
DECLARE @sSQL NVarchar(1000)
SET @sSQL= "

DECLARE @hDoc int
DECLARE @xml xml

set @xml=(select convert(xml,BulkColumn, 2)
From openrowset(Bulk'"+ @FileName + "', single_blob) [rowsetresults]);

exec sp_xml_preparedocument @hDoc OUTPUT, @xml
INSERT INTO CRA.LOADRECORDINGCONTRACT
SELECT *
FROM OPENXML(@hDoc, 'ROWSET/ROW',2)
WITH (CRRE_ID BIGINT,
GTA_COMPANY_ID VARCHAR(10),
CONTRIBUTOR_ID BIGINT,
CREATION_DATETIME DATETIME,
CRCR_NO_RIGHTS_IND CHAR(1),
CRCR_NO_MASTER_IND CHAR(1),
CRCR_NO_MULTI_ARTIST_IND CHAR(1),
RMS_ID BIGINT,
ISRC VARCHAR(20))
exec sp_xml_removedocument @hDoc ";

EXEC sp_executesql @sSQL 

set @insertCount = @@rowcount;

set @filename = RIGHT(@FileName, CHARINDEX('\', REVERSE(@FileName))-1);
set @filename = substring(@filename,0,24);

INSERT INTO Admin.DataIngestion (SourceID,RecordsReceived,StartRunDateTime,ProcessStep,Process)
values ('CRA',@insertCount,getdate(),'CRA.LoadRecordingContract',@filename);	
	
return @@rowcount

END