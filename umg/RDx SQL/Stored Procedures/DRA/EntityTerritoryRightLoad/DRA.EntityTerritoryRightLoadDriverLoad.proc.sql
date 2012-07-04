-- ============================================
-- Description:	Inserts records in DRA.LoadEntityTerritoryRightDriver
-- =============================================
CREATE PROCEDURE DRA.[EntityTerritoryRightLoadDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from DRA.LoadEntityTerritoryRightDriver where WORKFLOW_CODE = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
	-- New Records
	insert into DRA.LoadEntityTerritoryRightDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		TERRITORY_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_SET_ID,
		l.TERRITORY_ID,
		'L',
		'I',
		@timestamp 
	from 
		DRA.LoadEntityTerritoryRight l
		left outer join DRA.EntityTerritoryRight t 
			on l.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID and l.TERRITORY_ID = t.TERRITORY_ID
	where 		
		(t.ENTITY_CLEARANCE_SET_ID is null) and (t.TERRITORY_ID is null)
		and
		l.WORKFLOW_CODE = 'LT'
		
	set @rowcount = @rowcount + @@rowcount

	-- Updates
	insert into DRA.LoadEntityTerritoryRightDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		TERRITORY_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_SET_ID,
		l.TERRITORY_ID,		
		'L',
		'U',
		@timestamp 
	from 
		DRA.LoadEntityTerritoryRight l
		inner join DRA.EntityTerritoryRight t 
			on l.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID and l.TERRITORY_ID = t.TERRITORY_ID
	where
		l.WORKFLOW_CODE = 'LT'	
		
	set @rowcount = @rowcount + @@rowcount						

	-- mark as deleted (i.e. set CHANGE_CODE = 'UD') those records that have been deleted from the source table
	insert into DRA.LoadEntityTerritoryRightDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		TERRITORY_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_SET_ID,
		l.TERRITORY_ID,		
		'L',
		'UD',
		@timestamp 
	from
		DRA.LoadEntityTerritoryRight l
	where
		l.CHANGE_CODE = 'D' and l.WORKFLOW_CODE = 'LT'

	set @rowcount = @rowcount + @@rowcount		

	-- mark as deleted (i.e. set CHANGE_CODE = 'UD') those records that have been removed from the clearance set.
	insert into DRA.LoadEntityTerritoryRightDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		TERRITORY_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		t.ENTITY_CLEARANCE_SET_ID,
		t.TERRITORY_ID,		
		'L',
		'UD',
		@timestamp 
	from 
		(
			-- this gets all records in LoadEntityTerritoryRight for ENTITY_CLEARANCE_SET_ID that also exist in EntityTerritoryRight
			select distinct t.ENTITY_CLEARANCE_SET_ID, t.TERRITORY_ID
			from 
				DRA.EntityTerritoryRight t 
				inner join DRA.LoadEntityTerritoryRight l
					on t.ENTITY_CLEARANCE_SET_ID = l.ENTITY_CLEARANCE_SET_ID
			where 
				l.WORKFLOW_CODE = 'LT'					
		)as t
		-- left join to LoadEntityTerritoryRight on all fields to see which records are not in LoadEntityTerritoryRight
		-- those records will have to be deleted from EntityTerritoryRight
		left outer join DRA.LoadEntityTerritoryRight l 
			on t.ENTITY_CLEARANCE_SET_ID = l.ENTITY_CLEARANCE_SET_ID and t.TERRITORY_ID = l.TERRITORY_ID
	where
		(l.ENTITY_CLEARANCE_SET_ID is null) and (l.TERRITORY_ID is null)
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
	
END
GO