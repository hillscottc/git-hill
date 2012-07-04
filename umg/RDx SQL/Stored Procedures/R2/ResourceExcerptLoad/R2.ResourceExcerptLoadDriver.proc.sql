-- ============================================
-- Description:	Inserts records in R2.LoadResourceExcerptDriver
-- =============================================
CREATE PROCEDURE [R2].[ResourceExcerptLoadDriver] 
AS
BEGIN

	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into R2.LoadResourceExcerptDriver 
	(
		[RESOURCE_RESOURCE_LINK_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[RESOURCE_RESOURCE_LINK_ID], 
		'L',
		'I',
		@timestamp 
	from 
		R2.LoadResourceExcerpt l
		left outer join R2.ResourceExcerpt t 
			on l.[RESOURCE_RESOURCE_LINK_ID] = t.[RESOURCE_RESOURCE_LINK_ID]
	where
		t.[RESOURCE_RESOURCE_LINK_ID] is null

	set @rowcount = @rowcount + @@rowcount

-- Updates
	insert into R2.LoadResourceExcerptDriver 
	(
		[RESOURCE_RESOURCE_LINK_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[RESOURCE_RESOURCE_LINK_ID], 
		'L',
		'U',
		@timestamp 
	from 
		R2.LoadResourceExcerpt l
		inner join R2.ResourceExcerpt t on l.[RESOURCE_RESOURCE_LINK_ID] = t.[RESOURCE_RESOURCE_LINK_ID]
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
END
GO