-- ============================================
-- Description:	Loads records from DRA.ENTITY_COUNTRY_RIGHT into DRA.LoadEntityCountryRight
-- =============================================
CREATE PROCEDURE DRA.ExtractLoadEntityCountryRightInsert(@entityClearanceSetID numeric (38, 0))
AS
begin
	insert into DRA.LoadEntityCountryRight
	(
			ENTITY_CLEARANCE_SET_ID, 
			COUNTRY_ID, 
			MEMBERSHIP_STATE
	)
	execute 
	('
		SELECT 
			E.ENTITY_CLEARANCE_SET_ID, 
			E.COUNTRY_ID, 
			E.MEMBERSHIP_STATE
		FROM 
			DRA.ENTITY_COUNTRY_RIGHT E
		WHERE
			E.ENTITY_CLEARANCE_SET_ID = ' + @entityClearanceSetID
	) at DRA
	
	if (@@rowcount > 0)
		return;
	
	-- If @@rowcount is 0 there are no records in the source table.
	-- Now go to our own table and schedule any existing records for deletion
	insert into DRA.LoadEntityCountryRight
	(
		ENTITY_CLEARANCE_SET_ID, 
		COUNTRY_ID, 
		MEMBERSHIP_STATE,
		CHANGE_CODE
	)
	select 
		t.ENTITY_CLEARANCE_SET_ID,
		t.COUNTRY_ID,		
		t.MEMBERSHIP_STATE,
		'D'
	from
		DRA.EntityCountryRight t 
	where
		t.ENTITY_CLEARANCE_SET_ID = @entityClearanceSetID
end;	


