create PROCEDURE [PO].[ReleaseLoad]
	@FileName NVarchar(500),
	@retVal int = -1 OUTPUT 
AS
begin
	DECLARE @DeleteCount integer;
	DECLARE @InsertCount integer;	
	SELECT @DeleteCount = COUNT(*) from PO.Release;

	TRUNCATE TABLE PO.Release;

	INSERT INTO PO.Release
	(UPC, Release_Date, Release_Rights)
	SELECT UPC, Release_Date, Release_Rights
	FROM PO.LoadRelease; 

	set @InsertCount = @@rowcount;
	
	set @filename = RIGHT(@FileName, CHARINDEX('\', REVERSE(@FileName))-1);

	update admin.dataingestion 
	set RecordsInserted = @InsertCount,
		RecordsUpdated = 0,
		RecordsDeleted = @DeleteCount,
		RecordsErrored = 0,
		EndRunDateTime = GetDate()
	where process = @filename
	and ProcessStep = 'PO.LoadRelease';

	return @@rowcount	
END
