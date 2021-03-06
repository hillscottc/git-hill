﻿-- ============================================
-- Description:	Inserts records in DRA.LoadEntityClearanceDriver
-- =============================================
CREATE PROCEDURE DRA.[EntityClearanceLoadDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from DRA.LoadEntityClearanceDriver where WORKFLOW_CODE = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
	-- New Records
	insert into DRA.LoadEntityClearanceDriver 
	(
		ENTITY_CLEARANCE_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_ID,
		'L',
		'I',
		@timestamp 
	from 
		DRA.LoadEntityClearance l
		left outer join DRA.EntityClearance t 
			on l.ENTITY_CLEARANCE_ID = t.ENTITY_CLEARANCE_ID
	where 		
		(t.ENTITY_CLEARANCE_ID is null)
		and
		l.WORKFLOW_CODE = 'LT'
		
	set @rowcount = @rowcount + @@rowcount

	-- Updates
	insert into DRA.LoadEntityClearanceDriver 
	(
		ENTITY_CLEARANCE_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_ID,
		'L',
		'U',
		@timestamp 
	from 
		DRA.LoadEntityClearance l
		inner join DRA.EntityClearance t 
			on l.ENTITY_CLEARANCE_ID = t.ENTITY_CLEARANCE_ID
	where
		l.WORKFLOW_CODE = 'LT'	
		
	set @rowcount = @rowcount + @@rowcount						

	-- mark as deleted (i.e. set CHANGE_CODE = 'UD') those records that have been deleted from the source table
	insert into DRA.LoadEntityClearanceDriver 
	(
		ENTITY_CLEARANCE_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_ID,
		'L',
		'UD',
		l.CHANGE_DATE_TIME 
	from
		DRA.LoadEntityClearance l
	where
		l.CHANGE_CODE = 'D' and l.WORKFLOW_CODE = 'LT'

	set @rowcount = @rowcount + @@rowcount		

	-- mark as deleted (i.e. set CHANGE_CODE = 'UD') those records that have been removed from the clearance set.
	insert into DRA.LoadEntityClearanceDriver 
	(
		ENTITY_CLEARANCE_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		t.ENTITY_CLEARANCE_ID,
		'L',
		'UD',
		@timestamp 
	from 
		(
			-- this gets all records in LoadEntityClearance for ENTITY_CLEARANCE_SET_ID that also exist in EntityClearance
			select distinct t.ENTITY_CLEARANCE_ID
			from 
				DRA.EntityClearance t 
				inner join DRA.LoadEntityClearance l
					on t.ENTITY_CLEARANCE_SET_ID = l.ENTITY_CLEARANCE_SET_ID
			where 
				l.WORKFLOW_CODE = 'LT'					
		)as t
		-- left join to LoadEntityClearance on all fields to see which records are not in LoadEntityClearance
		-- those records will have to be deleted from EntityClearance
		left outer join DRA.LoadEntityClearance l 
			on t.ENTITY_CLEARANCE_ID = l.ENTITY_CLEARANCE_ID
	where
		(l.ENTITY_CLEARANCE_ID is null)
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
	
END
GO