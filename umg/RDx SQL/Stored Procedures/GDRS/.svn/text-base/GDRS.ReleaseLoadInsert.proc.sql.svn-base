CREATE PROCEDURE [GDRS].[ReleaseLoadInsert] 
	@FileName NVarchar(500),
	@retVal int = -1 OUTPUT 
AS
BEGIN
	DECLARE @InsertCount integer;

	insert into GDRS.Release
	select 
		[UPC] = l.[UPC],
		[Release_ID] = l.[Release_ID],
		[ReleaseDate] = l.[ReleaseDate],
		[Status] = l.[Status],
		[TerritorialRights] = l.[TerritorialRights],
		[ReleasingCountry] = l.[ReleasingCountry],
		[SoundtrackInd] = l.[SoundtrackInd],
		[Company_ID] = l.[Company_ID],
		CHANGECODE = ld.CHANGECODE,
		CHANGEDATETIME = getdate(),
		WORKFLOWCODE = 'E'
	from GDRS.LoadRelease l 
	inner join GDRS.LoadReleaseDriver ld 		
		on l.loadrelease_id = ld.loadrelease_id
	where ld.CHANGECODE = 'I'  and ld.[WORKFLOWCODE] = 'E'
	order by ld.loadrelease_id;	
	
	SET @InsertCount = @@Rowcount;

	set @filename = RIGHT(@FileName, CHARINDEX('\', REVERSE(@FileName))-1);

	update admin.dataingestion 
	set RecordsInserted = @InsertCount,
		RecordsUpdated = 0,
		RecordsDeleted = 0,
		RecordsErrored = 0,
		EndRunDateTime = GetDate()
	where process = @filename
	and ProcessStep = 'GDRS.LoadRelease';

	UPDATE GDRS.LoadReleaseDriver 
	SET WORKFLOWCODE = 'L'	
	where CHANGECODE = 'I' 
	and WORKFLOWCODE = 'E';	

	return @@rowcount
END
