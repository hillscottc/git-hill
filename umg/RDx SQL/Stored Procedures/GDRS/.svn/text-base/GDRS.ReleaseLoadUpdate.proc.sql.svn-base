CREATE PROCEDURE [GDRS].[ReleaseLoadUpdate]
	@FileName NVarchar(500),
	@retVal int = -1 OUTPUT 
AS
BEGIN
	DECLARE @DeleteCount integer;

	update GDRS.Release
	set
		[UPC] = l.[UPC],
		[Release_ID] = l.[Release_ID],
		[ReleaseDate] = l.[ReleaseDate],
		[Status] = l.[Status],
		[TerritorialRights] = l.[TerritorialRights],
		[ReleasingCountry] = l.[ReleasingCountry],
		[SoundtrackInd] = l.[SoundtrackInd],
		[Company_ID] = l.[Company_ID],
		ChangeCode = ld.ChangeCode,
		ChangeDatetime = getdate(),
		WorkflowCode = 'L'
	from GDRS.LoadRelease l 
	inner join GDRS.LoadReleaseDriver ld 		
		on l.loadrelease_id = ld.loadrelease_id
	where l.upc = release.upc
	and l.company_id = release.company_id
	and l.Release_ID = release.Release_ID
	and ld.CHANGECODE = 'U'  
	and ld.[WORKFLOWCODE] = 'E';

	set @DeleteCount = @@rowcount;

	set @filename = RIGHT(@FileName, CHARINDEX('\', REVERSE(@FileName))-1);

	update admin.dataingestion 
	set 	RecordsUpdated = @DeleteCount,
		RecordsDeleted = 0,
		RecordsErrored = 0,
		EndRunDateTime = GetDate()
	where process = @filename
	and ProcessStep = 'GDRS.LoadRelease';

	UPDATE GDRS.LoadReleaseDriver 
	SET WORKFLOWCODE = 'L'	
	where CHANGECODE = 'U' 
	and WORKFLOWCODE = 'E';	

	return @@rowcount	
END
