﻿-- ============================================
-- Description:	Inserts records in DRA.LoadEntityRightsPeriodDriver
-- =============================================
CREATE PROCEDURE DRA.[EntityRightsPeriodLoadDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from DRA.LoadEntityRightsPeriodDriver where WORKFLOW_CODE = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
	-- New Records
	insert into DRA.LoadEntityRightsPeriodDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		RIGHTS_PERIOD_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_SET_ID,
		l.RIGHTS_PERIOD_ID,
		'L',
		'I',
		@timestamp 
	from 
		DRA.LoadEntityRightsPeriod l
		left outer join DRA.EntityRightsPeriod t 
			on l.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID and l.RIGHTS_PERIOD_ID = t.RIGHTS_PERIOD_ID
	where 		
		(t.ENTITY_CLEARANCE_SET_ID is null) and (t.RIGHTS_PERIOD_ID is null)
		and
		l.WORKFLOW_CODE = 'LT'
		
	set @rowcount = @rowcount + @@rowcount

	-- Updates
	insert into DRA.LoadEntityRightsPeriodDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		RIGHTS_PERIOD_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_SET_ID,
		l.RIGHTS_PERIOD_ID,		
		'L',
		'U',
		@timestamp 
	from 
		DRA.LoadEntityRightsPeriod l
		inner join DRA.EntityRightsPeriod t 
			on l.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID and l.RIGHTS_PERIOD_ID = t.RIGHTS_PERIOD_ID
	where
		l.WORKFLOW_CODE = 'LT'	
		
	set @rowcount = @rowcount + @@rowcount						

	-- mark as deleted (i.e. set CHANGE_CODE = 'UD') those records that have been deleted from the source table
	insert into DRA.LoadEntityRightsPeriodDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		RIGHTS_PERIOD_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_SET_ID,
		l.RIGHTS_PERIOD_ID,		
		'L',
		'UD',
		@timestamp 
	from
		DRA.LoadEntityRightsPeriod l
	where
		l.CHANGE_CODE = 'D' and l.WORKFLOW_CODE = 'LT'

	set @rowcount = @rowcount + @@rowcount		

	-- mark as deleted (i.e. set CHANGE_CODE = 'UD') those records that have been removed from the clearance set.
	insert into DRA.LoadEntityRightsPeriodDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		RIGHTS_PERIOD_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		t.ENTITY_CLEARANCE_SET_ID,
		t.RIGHTS_PERIOD_ID,		
		'L',
		'UD',
		@timestamp 
	from 
		(
			-- this gets all records in LoadEntityRightsPeriod for ENTITY_CLEARANCE_SET_ID that also exist in EntityRightsPeriod
			select distinct t.ENTITY_CLEARANCE_SET_ID, t.RIGHTS_PERIOD_ID
			from 
				DRA.EntityRightsPeriod t 
				inner join DRA.LoadEntityRightsPeriod l
					on t.ENTITY_CLEARANCE_SET_ID = l.ENTITY_CLEARANCE_SET_ID
			where 
				l.WORKFLOW_CODE = 'LT'					
		)as t
		-- left join to LoadEntityRightsPeriod on all fields to see which records are not in LoadEntityRightsPeriod
		-- those records will have to be deleted from EntityRightsPeriod
		left outer join DRA.LoadEntityRightsPeriod l 
			on t.ENTITY_CLEARANCE_SET_ID = l.ENTITY_CLEARANCE_SET_ID and t.RIGHTS_PERIOD_ID = l.RIGHTS_PERIOD_ID
	where
		(l.ENTITY_CLEARANCE_SET_ID is null) and (l.RIGHTS_PERIOD_ID is null)
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
	
END
GO