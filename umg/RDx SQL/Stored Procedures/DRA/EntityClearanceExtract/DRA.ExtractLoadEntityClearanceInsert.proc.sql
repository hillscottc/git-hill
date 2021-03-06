﻿-- ============================================
-- Description:	Loads records from DRA.ENTITY_CLEARANCE into DRA.LoadEntityClearance
-- =============================================
CREATE PROCEDURE DRA.ExtractLoadEntityClearanceInsert(@entityClearanceSetID numeric (38, 0))
AS
begin
	insert into DRA.LoadEntityClearance
	(
		ENTITY_CLEARANCE_ID, 
		ENTITY_CLEARANCE_SET_ID, 
		EXPLOITATION_ID, 
		CLEARANCE_ID, 
		CLEARANCE_STATE, 
		DISAGGREGATION_FLAG, 
		NOTES, 
		REJECTION_NOTES
	)
	execute 
	('
		SELECT 
			E.ENTITY_CLEARANCE_ID, 
			E.ENTITY_CLEARANCE_SET_ID, 
			E.EXPLOITATION_ID, 
			E.CLEARANCE_ID, 
			E.CLEARANCE_STATE, 
			E.DISAGGREGATION_FLAG, 
			E.NOTES, 
			E.REJECTION_NOTES
		FROM 
			DRA.ENTITY_CLEARANCE E
		WHERE
			E.ENTITY_CLEARANCE_SET_ID = ' + @entityClearanceSetID
	) at DRA
	
	if (@@rowcount > 0)
		return;
	
	-- If @@rowcount is 0 there are no records in the source table.
	-- Now go to our own table and schedule any existing records for deletion
	insert into DRA.LoadEntityClearance
	(
		ENTITY_CLEARANCE_ID, 
		ENTITY_CLEARANCE_SET_ID, 
		EXPLOITATION_ID, 
		CLEARANCE_ID, 
		CLEARANCE_STATE, 
		DISAGGREGATION_FLAG, 
		NOTES, 
		REJECTION_NOTES,
		CHANGE_CODE
	)
	select 
		t.ENTITY_CLEARANCE_ID, 
		t.ENTITY_CLEARANCE_SET_ID, 
		t.EXPLOITATION_ID, 
		t.CLEARANCE_ID, 
		t.CLEARANCE_STATE, 
		t.DISAGGREGATION_FLAG, 
		t.NOTES, 
		t.REJECTION_NOTES,
		'D'
	from
		DRA.EntityClearance t 
	where
		t.ENTITY_CLEARANCE_SET_ID = @entityClearanceSetID
	
end;	


