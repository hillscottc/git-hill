﻿-- ============================================
-- Description:	Inserts records in R2.LoadResourceDriver
-- =============================================
CREATE PROCEDURE [R2].[ResourceLoadDriverLoad] 
AS
BEGIN

	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from R2.LoadResourceDriver where [WORKFLOW_CODE] = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;


	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into R2.LoadResourceDriver 
	(
		[RESOURCE_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[RESOURCE_ID],
		'L',
		case when l.[CHANGE_CODE] = 'C' then 'I' else 'ID' end,
		l.CHANGE_DATE_TIME
	from 
		R2.LoadResource l
		left outer join R2.Resource t 
			on l.[Resource_ID] = t.[Resource_ID]
	where 
		(t.[Resource_ID] is null)
		and
		(l.[WORKFLOW_CODE] = 'LT')

	set @rowcount = @rowcount + @@rowcount

-- Updates
	insert into R2.LoadResourceDriver 
	(
		[RESOURCE_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[RESOURCE_ID],
		'L',
		case when l.[CHANGE_CODE] = 'C' then 'U' else 'UD' end,
		l.CHANGE_DATE_TIME
	from 
		R2.LoadResource l
		inner join R2.Resource t 
			on l.[Resource_ID] = t.[Resource_ID] 
	where 
		(l.[WORKFLOW_CODE] = 'LT')
		
	set @rowcount = @rowcount + @@rowcount		
	
	return @rowcount
END
GO