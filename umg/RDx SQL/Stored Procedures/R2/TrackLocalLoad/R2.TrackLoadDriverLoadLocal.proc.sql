﻿-- ============================================
-- Description:	Inserts records in R2.LoadTrackLocalDriver
-- =============================================
CREATE PROCEDURE [R2].[TrackLoadDriverLoadLocal] 
AS
BEGIN

	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from R2.LoadTrackLocalDriver where [WORKFLOW_CODE] = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;

	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into R2.LoadTrackLocalDriver 
	(
		[RELEASE_ID],
		[RESOURCE_ID],
		[GROUP_SEQUENCE_NO],
		[SEQUENCE_NO],
		[COMPANY_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[RELEASE_ID],
		l.[RESOURCE_ID],
		l.[GROUP_SEQUENCE_NO],
		l.[SEQUENCE_NO],
		l.[COMPANY_ID],
		'L',
		case when l.[CHANGE_CODE] = 'C' then 'I' else 'ID' end,
		l.CHANGE_DATE_TIME
	from 
		R2.LoadTrackLocal l
		left outer join R2.TrackLocal t 
			on l.RELEASE_ID = t.RELEASE_ID and l.RESOURCE_ID = t.RESOURCE_ID 
				and l.GROUP_SEQUENCE_NO = t.GROUP_SEQUENCE_NO and l.SEQUENCE_NO = t.SEQUENCE_NO 
				and l.COMPANY_ID = t.COMPANY_ID
			 
	where 
		(
			t.[RELEASE_ID] is null and t.[RESOURCE_ID] is null 
			and t.GROUP_SEQUENCE_NO is null and t.SEQUENCE_NO is null
			and t.[COMPANY_ID] is null 
		)
		and
		(l.[WORKFLOW_CODE] = 'LT')

	set @rowcount = @rowcount + @@rowcount

-- Updates
	insert into R2.LoadTrackLocalDriver 
	(
		[RELEASE_ID],
		[RESOURCE_ID],
		[GROUP_SEQUENCE_NO],
		[SEQUENCE_NO],
		[COMPANY_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select  
		l.[RELEASE_ID],
		l.[RESOURCE_ID],
		l.[GROUP_SEQUENCE_NO],
		l.[SEQUENCE_NO],
		l.[COMPANY_ID],
		'L',
		case when l.[CHANGE_CODE] = 'C' then 'U' else 'UD' end,
		l.CHANGE_DATE_TIME
	from 
		R2.LoadTrackLocal l
		inner join R2.TrackLocal t 
			on l.RELEASE_ID = t.RELEASE_ID and l.RESOURCE_ID = t.RESOURCE_ID 
				and l.GROUP_SEQUENCE_NO = t.GROUP_SEQUENCE_NO and l.SEQUENCE_NO = t.SEQUENCE_NO 
				and l.COMPANY_ID = t.COMPANY_ID
	where 
		(l.[WORKFLOW_CODE] = 'LT')
		
	set @rowcount = @rowcount + @@rowcount		
	
	return @rowcount
END
GO