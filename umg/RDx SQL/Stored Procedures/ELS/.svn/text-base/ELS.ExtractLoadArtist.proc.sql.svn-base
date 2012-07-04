CREATE PROCEDURE [ELS].[ExtractLoadArtist] 
	@FileName NVarchar(512),
	@retVal int = -1 OUTPUT 
AS
BEGIN
	truncate table ELS.LoadArtist;
	
	DECLARE @insertCount integer;
	DECLARE @sSQL nvarchar(400)

	SET @sSQL= "BULK INSERT ELS.LoadArtist FROM '" +@FileName + "' WITH (FIRSTROW = 2)"; 
	EXEC sp_executesql @sSQL 

	set @insertCount = @@rowcount;

	set @filename = RIGHT(@FileName, CHARINDEX('\', REVERSE(@FileName))-1);

	INSERT INTO Admin.DataIngestion (SourceID,RecordsReceived,StartRunDateTime,ProcessStep,Process)
	values ('ELS',@insertCount,getdate(),'ELS.LoadArtist',@filename);

	update els.loadartist
	set TITLE = replace(TITLE,'"',''),
	CONTRACT_ID = replace(CONTRACT_ID,'"',''),
	ISRC = replace(ISRC,'"',''),
	CONTRACT_NAME = replace(CONTRACT_NAME,'"',''),
	ARTISTFULLNAME = replace(ARTISTFULLNAME,'"',''),
	ARTIST_CONSENT_REQUIRED = replace(ARTIST_CONSENT_REQUIRED,'"','');
	
	return @@rowcount
END