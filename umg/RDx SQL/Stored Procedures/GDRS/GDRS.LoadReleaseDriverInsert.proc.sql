CREATE PROCEDURE [GDRS].[LoadReleaseDriverInsert]
	@retVal int = -1 OUTPUT 
AS
begin
	declare @existingJobRows int
	set @existingJobRows = 0

	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into GDRS.LoadReleaseDriver 
	(
		LoadRelease_ID,
		UPC,
		Company_ID,
		Release_ID,
		WorkflowCode,
		ChangeCode,
		ChangeDatetime
	)
	select 
		loadrelease.loadrelease_id,
		loadRelease.UPC, 
		loadRelease.Company_ID, 
		loadRelease.Release_ID, 
		'E',
		'I',
		@timestamp 
	from gdrs.loadRelease where not exists (
		select *
		from GDRS.Release 
		where loadRelease.UPC = release.UPC 
		and loadrelease.company_id = release.company_id
		and loadrelease.release_id = release.release_id)
	and Release_id is not null
	and company_id is not null;
	--and status = 'Active';
	
	set @rowcount = @rowcount + @@rowcount

-- Updates

	insert into GDRS.LoadReleaseDriver 
	(
		LoadRelease_ID,
		UPC,
		Company_ID,
		Release_ID,
		WorkflowCode,
		ChangeCode,
		ChangeDatetime
	)
	select 
		loadrelease.loadrelease_id,
		loadRelease.UPC, 
		loadRelease.Company_ID, 
		loadRelease.Release_ID, 
		'E',
		'U',
		@timestamp 
	from gdrs.loadRelease where exists (
		select *
		from GDRS.Release 
		where loadRelease.UPC = release.UPC 
		and loadrelease.company_id = release.company_id
		and loadrelease.release_id = release.release_id)
	and Release_id is not null
	and company_id is not null;
	--and status = 'Active';

	set @rowcount = @rowcount + @@rowcount		
	return @rowcount	
END
