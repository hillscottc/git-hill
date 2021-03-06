﻿-- ============================================
-- Description:	Loads records from DRA.ENTITY_TERRITORY_RIGHT into DRA.LoadEntityTerritoryRight
-- =============================================
CREATE PROCEDURE DRA.ExtractLoadEntityTerritoryRightInsert(@entityClearanceSetID numeric (38, 0))
AS
begin
	insert into DRA.LoadEntityTerritoryRight
	(
		ENTITY_CLEARANCE_SET_ID, 
		TERRITORY_ID, 
		MEMBERSHIP_STATE
	)
	execute 
	('
		SELECT 
			E.ENTITY_CLEARANCE_SET_ID, 
			E.TERRITORY_ID, 
			E.MEMBERSHIP_STATE
		FROM 
			DRA.ENTITY_TERRITORY_RIGHT E
		WHERE
			E.ENTITY_CLEARANCE_SET_ID = ' + @entityClearanceSetID
	) at DRA
	
	if (@@rowcount > 0)
		return;
	
	-- If @@rowcount is 0 there are no records in the source table.
	-- Now go to our own table and schedule any existing records for deletion
	insert into DRA.LoadEntityTerritoryRight
	(
		ENTITY_CLEARANCE_SET_ID, 
		TERRITORY_ID, 
		MEMBERSHIP_STATE,
		CHANGE_CODE
	)
	select 
		t.ENTITY_CLEARANCE_SET_ID,
		t.TERRITORY_ID, 
		t.MEMBERSHIP_STATE,
		'D'
	from
		DRA.EntityTerritoryRight t 
	where
		t.ENTITY_CLEARANCE_SET_ID = @entityClearanceSetID	
	
end;	


