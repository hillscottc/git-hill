-- ============================================
-- Description:	Inserts records in DRA.LoadEntityCountryRightMVDriver
-- =============================================
CREATE PROCEDURE DRA.[EntityCountryRightMVLoadDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from DRA.LoadEntityCountryRightMVDriver where WORKFLOW_CODE = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
	-- New Records
	insert into DRA.LoadEntityCountryRightMVDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		COUNTRY_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_SET_ID,
		l.COUNTRY_ID,
		'L',
		'I',
		@timestamp 
	from 
		DRA.LoadEntityCountryRightMV l
		left outer join DRA.EntityCountryRightMV t 
			on l.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID and l.COUNTRY_ID = t.COUNTRY_ID
	where 		
		(t.ENTITY_CLEARANCE_SET_ID is null) and (t.COUNTRY_ID is null)
		and
		l.WORKFLOW_CODE = 'LT'
		
	set @rowcount = @rowcount + @@rowcount

	-- Updates
	insert into DRA.LoadEntityCountryRightMVDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		COUNTRY_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_SET_ID,
		l.COUNTRY_ID,		
		'L',
		'U',
		@timestamp 
	from 
		DRA.LoadEntityCountryRightMV l
		inner join DRA.EntityCountryRightMV t 
			on l.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID and l.COUNTRY_ID = t.COUNTRY_ID
	where
		l.WORKFLOW_CODE = 'LT'	
		
	set @rowcount = @rowcount + @@rowcount						

	-- mark as deleted (i.e. set CHANGE_CODE = 'UD') those records that have been deleted from the source table
	insert into DRA.LoadEntityCountryRightMVDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		COUNTRY_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.ENTITY_CLEARANCE_SET_ID,
		l.COUNTRY_ID,		
		'L',
		'UD',
		@timestamp 
	from
		DRA.LoadEntityCountryRightMV l
	where
		l.CHANGE_CODE = 'D' and l.WORKFLOW_CODE = 'LT'

	set @rowcount = @rowcount + @@rowcount		

	-- mark as deleted (i.e. set CHANGE_CODE = 'UD') those records that have been removed from the clearance set.
	insert into DRA.LoadEntityCountryRightMVDriver 
	(
		ENTITY_CLEARANCE_SET_ID,
		COUNTRY_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		t.ENTITY_CLEARANCE_SET_ID,
		t.COUNTRY_ID,		
		'L',
		'UD',
		@timestamp 
	from 
		(
			-- this gets all records in LoadEntityCountryRightMV for ENTITY_CLEARANCE_SET_ID that also exist in EntityCountryRightMV
			select distinct t.ENTITY_CLEARANCE_SET_ID, t.COUNTRY_ID
			from 
				DRA.EntityCountryRightMV t 
				inner join DRA.LoadEntityCountryRightMV l
					on t.ENTITY_CLEARANCE_SET_ID = l.ENTITY_CLEARANCE_SET_ID
			where 
				l.WORKFLOW_CODE = 'LT'					
		)as t
		-- left join to LoadEntityCountryRightMV on all fields to see which records are not in LoadEntityCountryRightMV
		-- those records will have to be deleted from EntityCountryRightMV
		left outer join DRA.LoadEntityCountryRightMV l 
			on t.ENTITY_CLEARANCE_SET_ID = l.ENTITY_CLEARANCE_SET_ID and t.COUNTRY_ID = l.COUNTRY_ID
	where
		(l.ENTITY_CLEARANCE_SET_ID is null) and (l.COUNTRY_ID is null)
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
	
END
GO