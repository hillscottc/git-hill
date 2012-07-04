CREATE PROCEDURE [CRA].[RecordingContractLoad]
	@FileName NVarchar(500),
	@retVal int = -1 OUTPUT 
AS
begin
	DECLARE @insertCount integer;
	DECLARE @DeleteCount integer;	
	SELECT @DeleteCount = COUNT(*) from CRA.RecordingContract;

	TRUNCATE TABLE CRA.RecordingContract;

	INSERT INTO CRA.RecordingContract 
	(CRRE_ID,GTA_COMPANY_ID,CONTRIBUTOR_ID,CREATION_DATETIME,CRCR_NO_RIGHTS_IND,CRCR_NO_MASTER_IND,CRCR_NO_MULTI_ARTIST_IND,RMS_ID,ISRC)
	SELECT CRRE_ID,GTA_COMPANY_ID,CONTRIBUTOR_ID,CREATION_DATETIME,CRCR_NO_RIGHTS_IND,CRCR_NO_MASTER_IND,CRCR_NO_MULTI_ARTIST_IND,RMS_ID,ISRC
	FROM CRA.LoadRecordingContract;  

	set @insertCount = @@rowcount;

	set @filename = RIGHT(@FileName, CHARINDEX('\', REVERSE(@FileName))-1);
	set @filename = substring(@filename,0,24);

	update admin.dataingestion 
	set RecordsInserted = @insertCount,
		RecordsUpdated = 0,
		RecordsDeleted = @DeleteCount,
		RecordsErrored = 0,
		EndRunDateTime = GetDate()
	where process = @filename
	and ProcessStep = 'CRA.LoadRecordingContract';

	return @@rowcount	
END
