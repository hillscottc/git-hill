CREATE PROCEDURE [CRL].[PreclearedVideoExtract]
	@FileName NVarchar(500),
	@retVal int = -1 OUTPUT 
AS
BEGIN

TRUNCATE TABLE CRL.LoadPreclearedVideo;

DECLARE @ReceiveCount integer;
DECLARE @sSQL NVarchar(1000)
SET @sSQL= "
DECLARE @hDoc int
DECLARE @xml xml

set @xml=(select convert(xml,BulkColumn, 2)
From openrowset(Bulk'"+ @FileName + "', single_blob) [rowsetresults]);

exec sp_xml_preparedocument @hDoc OUTPUT, @xml
INSERT INTO CRL.LoadPreclearedVideo
SELECT *
FROM OPENXML(@hDoc, 'ROWSET/ROW',2)
WITH (
PRECLEARED_VIDEO_ID NUMERIC(38,0),
ARTIST NVARCHAR(50),
VIDEO_TITLE NVARCHAR(50),
VIDEO_VERSION NVARCHAR(50),
VIDEO_UPC NVARCHAR(50),
AUDIO_UPC NVARCHAR(50),
VIDEO_ISRC NVARCHAR(50),
AUDIO_ISRC NVARCHAR(50),
TERRITORY NVARCHAR(50),
COMMERCIAL_RIGHTS NVARCHAR(50),
STATUS NCHAR(1),
OBJ_VER Int
)
exec sp_xml_removedocument @hDoc ";

EXEC sp_executesql @sSQL 
set @ReceiveCount = @@rowcount;

set @filename = RIGHT(@FileName, CHARINDEX('\', REVERSE(@FileName))-1);
set @filename = substring(@filename,0,24);

INSERT INTO Admin.DataIngestion (SourceID,RecordsReceived,StartRunDateTime,ProcessStep,Process)
values ('CARL',@ReceiveCount,getdate(),'CRL.LoadPreclearedVideo',@filename);
	
return @@rowcount

END