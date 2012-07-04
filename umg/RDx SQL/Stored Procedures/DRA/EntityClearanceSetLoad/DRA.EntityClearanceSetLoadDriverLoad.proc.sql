-- ============================================
-- Description:	Inserts records in DRA.LoadEntityClearanceSetDriver
-- =============================================
CREATE PROCEDURE DRA.[EntityClearanceSetLoadDriverLoad] 
AS
BEGIN

	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from DRA.LoadEntityClearanceSetDriver where [WORKFLOW_CODE] = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;

	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into DRA.LoadEntityClearanceSetDriver 
	(
		[ENTITY_CLEARANCE_SET_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[ENTITY_CLEARANCE_SET_ID],
		'L',
		case when l.[CHANGE_CODE] = 'C' then 'I' else 'ID' end,
		l.CHANGE_DATE_TIME
	from 
		DRA.LoadEntityClearanceSet l
		left outer join DRA.EntityClearanceSet t 
			on l.[ENTITY_CLEARANCE_SET_ID] = t.[ENTITY_CLEARANCE_SET_ID]
	where 
		(t.[ENTITY_CLEARANCE_SET_ID] is null)
		and
		(l.[WORKFLOW_CODE] = 'LT')

	set @rowcount = @rowcount + @@rowcount

-- Updates
	insert into DRA.LoadEntityClearanceSetDriver 
	(
		[ENTITY_CLEARANCE_SET_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[ENTITY_CLEARANCE_SET_ID],
		'L',
		case when l.[CHANGE_CODE] = 'C' then 'U' else 'UD' end,
		l.CHANGE_DATE_TIME
	from 
		DRA.LoadEntityClearanceSet l
		inner join DRA.EntityClearanceSet t 
			on l.[ENTITY_CLEARANCE_SET_ID] = t.[ENTITY_CLEARANCE_SET_ID] 
	where 
		(l.[WORKFLOW_CODE] = 'LT')
		
	set @rowcount = @rowcount + @@rowcount		
	
	-- mark as deleted (i.e. set CHANGE_CODE = 'UD') those records that have been deleted from the source table
	insert into DRA.LoadEntityClearanceSetDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_SET_ID,
		'L',
		'UD',
		l.CHANGE_DATE_TIME 
	from
		DRA.LoadEntityClearanceSet l
	where
		l.CHANGE_CODE = 'D' and l.WORKFLOW_CODE = 'LT'

	set @rowcount = @rowcount + @@rowcount		
	
	return @rowcount
END
GO