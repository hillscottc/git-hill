-- ============================================
-- Description:	Loads records from DRA.ENTITY_COUNTRY_RIGHT_MV into DRA.LoadEntityCountryRightMV
-- =============================================
CREATE PROCEDURE DRA.ExtractLoadEntityCountryRightMVInsert(@entityClearanceSetID numeric (38, 0))
AS
begin
	insert into DRA.LoadEntityCountryRightMV
	(
		ENTITY_CLEARANCE_SET_ID, 
		COUNTRY_ID
	)
	execute 
	('
		SELECT 
			E.ENTITY_CLEARANCE_SET_ID, 
			E.COUNTRY_ID
		FROM 
			DRA.ENTITY_COUNTRY_RIGHT_MV E
		WHERE
			E.ENTITY_CLEARANCE_SET_ID = ' + @entityClearanceSetID
	) at DRA
	
	if (@@rowcount > 0)
		return;
	
	-- If @@rowcount is 0 there are no records in the source table.
	-- Now go to our own table and schedule any existing records for deletion
	insert into DRA.LoadEntityCountryRightMV
	(
		ENTITY_CLEARANCE_SET_ID, 
		COUNTRY_ID, 
		CHANGE_CODE
	)
	select 
		t.ENTITY_CLEARANCE_SET_ID,
		t.COUNTRY_ID, 
		'D'
	from
		DRA.EntityCountryRightMV t 
	where
		t.ENTITY_CLEARANCE_SET_ID = @entityClearanceSetID	
end;	


