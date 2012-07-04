-- ============================================
-- Description:	Loads records from DRA.ENTITY_RIGHTS_PERIOD into DRA.LoadEntityRightsPeriod
-- =============================================
CREATE PROCEDURE DRA.ExtractLoadEntityRightsPeriodInsert(@entityClearanceSetID numeric (38, 0))
AS
begin
	insert into DRA.LoadEntityRightsPeriod
	(
		ENTITY_CLEARANCE_SET_ID, 
		RIGHTS_PERIOD_ID, 
		EXPIRY_DATE
	)
	execute 
	('
		SELECT 
			E.ENTITY_CLEARANCE_SET_ID, 
			E.RIGHTS_PERIOD_ID, 
			E.EXPIRY_DATE
		FROM 
			DRA.ENTITY_RIGHTS_PERIOD E
		WHERE
			E.ENTITY_CLEARANCE_SET_ID = ' + @entityClearanceSetID
	) at DRA
	
	if (@@rowcount > 0)
		return;
	
	-- If @@rowcount is 0 there are no records in the source table.
	-- Now go to our own table and schedule any existing records for deletion
	insert into DRA.LoadEntityRightsPeriod
	(
		ENTITY_CLEARANCE_SET_ID, 
		RIGHTS_PERIOD_ID, 
		EXPIRY_DATE,
		CHANGE_CODE
	)
	select 
		t.ENTITY_CLEARANCE_SET_ID,
		t.RIGHTS_PERIOD_ID, 
		t.EXPIRY_DATE,
		'D'
	from
		DRA.EntityRightsPeriod t 
	where
		t.ENTITY_CLEARANCE_SET_ID = @entityClearanceSetID	
end;	


