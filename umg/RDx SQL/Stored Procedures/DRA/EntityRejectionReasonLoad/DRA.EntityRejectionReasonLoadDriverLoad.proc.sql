﻿-- ============================================
-- Description:	Inserts records in DRA.LoadEntityRejectionReasonDriver
-- =============================================
CREATE PROCEDURE DRA.[EntityRejectionReasonLoadDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from DRA.LoadEntityRejectionReasonDriver where WORKFLOW_CODE = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
	-- New Records
	insert into DRA.LoadEntityRejectionReasonDriver 
	(
		ENTITY_CLEARANCE_ID,
		REJECTION_REASON_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_ID,
		l.REJECTION_REASON_ID,
		'L',
		'I',
		@timestamp 
	from 
		DRA.LoadEntityRejectionReason l
		left outer join DRA.EntityRejectionReason t 
			on l.ENTITY_CLEARANCE_ID = t.ENTITY_CLEARANCE_ID and l.REJECTION_REASON_ID = t.REJECTION_REASON_ID
	where 		
		(t.ENTITY_CLEARANCE_ID is null) and (t.REJECTION_REASON_ID is null)
		and
		l.WORKFLOW_CODE = 'LT'
		
	set @rowcount = @rowcount + @@rowcount

	-- Updates
	insert into DRA.LoadEntityRejectionReasonDriver 
	(
		ENTITY_CLEARANCE_ID,
		REJECTION_REASON_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_ID,
		l.REJECTION_REASON_ID,		
		'L',
		'U',
		@timestamp 
	from 
		DRA.LoadEntityRejectionReason l
		inner join DRA.EntityRejectionReason t 
			on l.ENTITY_CLEARANCE_ID = t.ENTITY_CLEARANCE_ID and l.REJECTION_REASON_ID = t.REJECTION_REASON_ID
	where
		l.WORKFLOW_CODE = 'LT'	
		
	set @rowcount = @rowcount + @@rowcount						

	-- mark as deleted (i.e. set CHANGE_CODE = 'UD') those records that have been deleted from the source table
	insert into DRA.LoadEntityRejectionReasonDriver 
	(
		ENTITY_CLEARANCE_ID,
		REJECTION_REASON_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_ID,
		l.REJECTION_REASON_ID,		
		'L',
		'UD',
		@timestamp 
	from
		DRA.LoadEntityRejectionReason l
	where
		l.CHANGE_CODE = 'D' and l.WORKFLOW_CODE = 'LT'

	set @rowcount = @rowcount + @@rowcount		

	-- mark as deleted (i.e. set CHANGE_CODE = 'UD') those records that have been removed from the clearance set.
	insert into DRA.LoadEntityRejectionReasonDriver 
	(
		ENTITY_CLEARANCE_ID,
		REJECTION_REASON_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		t.ENTITY_CLEARANCE_ID,
		t.REJECTION_REASON_ID,		
		'L',
		'UD',
		@timestamp 
	from 
		(
			-- this gets all records in LoadEntityRejectionReason for ENTITY_CLEARANCE_ID that also exist in EntityRejectionReason
			select distinct t.ENTITY_CLEARANCE_ID, t.REJECTION_REASON_ID
			from 
				DRA.EntityRejectionReason t 
				inner join DRA.LoadEntityRejectionReason l
					on t.ENTITY_CLEARANCE_ID = l.ENTITY_CLEARANCE_ID
			where 
				l.WORKFLOW_CODE = 'LT'					
		)as t
		-- left join to LoadEntityRejectionReason on all fields to see which records are not in LoadEntityRejectionReason
		-- those records will have to be deleted from EntityRejectionReason
		left outer join DRA.LoadEntityRejectionReason l 
			on t.ENTITY_CLEARANCE_ID = l.ENTITY_CLEARANCE_ID and t.REJECTION_REASON_ID = l.REJECTION_REASON_ID
	where
		(l.ENTITY_CLEARANCE_ID is null) and (l.REJECTION_REASON_ID is null)
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
	
END
GO