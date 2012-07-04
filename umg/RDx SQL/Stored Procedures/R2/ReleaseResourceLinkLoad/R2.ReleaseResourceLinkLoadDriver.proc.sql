﻿-- ============================================
-- Description:	Inserts records in R2.LoadReleaseResourceLinkDriver
-- =============================================
CREATE PROCEDURE [R2].[ReleaseResourceLinkLoadDriver] 
AS
BEGIN

	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into R2.LoadReleaseResourceLinkDriver 
	(
		[RELEASE_RESOURCE_LINK_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[RELEASE_RESOURCE_LINK_ID], 
		'L',
		'I',
		@timestamp 
	from 
		R2.LoadReleaseResourceLink l
		left outer join R2.ReleaseResourceLink t 
			on l.[RELEASE_RESOURCE_LINK_ID] = t.[RELEASE_RESOURCE_LINK_ID]
	where 
		t.[RELEASE_RESOURCE_LINK_ID] is null

	set @rowcount = @rowcount + @@rowcount

-- Updates
	insert into R2.LoadReleaseResourceLinkDriver 
	(
		[RELEASE_RESOURCE_LINK_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[RELEASE_RESOURCE_LINK_ID], 
		'L',
		'U',
		@timestamp 
	from 
		R2.LoadReleaseResourceLink l
		inner join R2.ReleaseResourceLink t on l.[RELEASE_RESOURCE_LINK_ID] = t.[RELEASE_RESOURCE_LINK_ID]
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
END
GO