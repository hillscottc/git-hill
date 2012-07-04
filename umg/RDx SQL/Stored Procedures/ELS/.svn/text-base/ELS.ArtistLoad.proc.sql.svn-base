CREATE PROCEDURE [ELS].[ArtistLoad]
	@FileName NVarchar(512),
	@retVal int = -1 OUTPUT 
AS
begin
	DECLARE @InsertCount integer;
	DECLARE @DeleteCount integer;

	SELECT @DeleteCount = COUNT(*) from ELS.Artist;

	TRUNCATE TABLE ELS.Artist;

	INSERT INTO ELS.Artist
	(Title,Contract_ID,ISRC,Contract_Name,ArtistFullName,Artist_Consent_Required)
	SELECT Title,Contract_ID,ISRC,Contract_Name,ArtistFullName,Artist_Consent_Required
	FROM ELS.LoadArtist; 

	set @insertCount = @@rowcount;

	set @filename = RIGHT(@FileName, CHARINDEX('\', REVERSE(@FileName))-1);

	update admin.dataingestion 
	set RecordsInserted = @InsertCount,
		RecordsUpdated = 0,
		RecordsDeleted = @DeleteCount,
		RecordsErrored = 0,
		EndRunDateTime = GetDate()
	where process = @filename
	and ProcessStep = 'ELS.LoadArtist';

	return @@rowcount	
END
