-- ============================================
-- Description:	Inserts records in R2.LoadReleasePackageDriver
-- =============================================
CREATE PROCEDURE [R2].[ReleasePackageLoadDriver] 
AS
BEGIN

	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into R2.LoadReleasePackageDriver 
	(
		[RELEASE_ID],
		[COMPONENT_RELEASE_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[RELEASE_ID],
		l.[COMPONENT_RELEASE_ID],
		'L',
		'I',
		@timestamp 
	from 
		R2.LoadReleasePackage l
		left outer join R2.ReleasePackage t 
			on l.[RELEASE_ID] = t.[RELEASE_ID] and l.[COMPONENT_RELEASE_ID] = t.[COMPONENT_RELEASE_ID]
	where 
		(t.[RELEASE_ID] is null) and (t.[COMPONENT_RELEASE_ID] is null)

	set @rowcount = @rowcount + @@rowcount

-- Updates
	insert into R2.LoadReleasePackageDriver 
	(
		[RELEASE_ID],
		[COMPONENT_RELEASE_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[RELEASE_ID],
		l.[COMPONENT_RELEASE_ID],
		'L',
		'U',
		@timestamp 
	from 
		R2.LoadReleasePackage l
		inner join R2.ReleasePackage t 
			on l.[RELEASE_ID] = t.[RELEASE_ID] and l.[COMPONENT_RELEASE_ID] = t.[COMPONENT_RELEASE_ID]
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
END
GO