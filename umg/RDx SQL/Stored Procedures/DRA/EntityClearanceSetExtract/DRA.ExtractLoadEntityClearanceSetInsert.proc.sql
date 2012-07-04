-- ============================================
-- Description:	Loads records from DRA.ENTITY_CLEARANCE_SET into DRA.LoadEntityClearanceSet
-- =============================================
CREATE PROCEDURE DRA.ExtractLoadEntityClearanceSetInsert(@entityClearanceSetID numeric (38, 0))
AS
begin
	insert into DRA.LoadEntityClearanceSet
	(
		ENTITY_CLEARANCE_SET_ID, 
		RESOURCE_ID, 
		RELEASE_ID, 
		TERRITORIAL_RIGHTS_NOTES, 
		TERRITORIAL_RIGHTS_NOTES_FLAG, 
		COMPANY_ID
	)
	execute 
	('
		SELECT 
			E.ENTITY_CLEARANCE_SET_ID, 
			E.RESOURCE_ID, 
			E.RELEASE_ID, 
			E.TERRITORIAL_RIGHTS_NOTES, 
			E.TERRITORIAL_RIGHTS_NOTES_FLAG, 
			E.COMPANY_ID
		FROM 
			DRA.ENTITY_CLEARANCE_SET E
		WHERE
			E.ENTITY_CLEARANCE_SET_ID = ' + @entityClearanceSetID
	) at DRA
	
	if (@@rowcount > 0)
		return;
	
	-- If @@rowcount is 0 there are no records in the source table.
	-- Now go to our own table and schedule any existing records for deletion
	insert into DRA.LoadEntityClearanceSet
	(
		ENTITY_CLEARANCE_SET_ID, 
		RESOURCE_ID, 
		RELEASE_ID, 
		TERRITORIAL_RIGHTS_NOTES, 
		TERRITORIAL_RIGHTS_NOTES_FLAG, 
		COMPANY_ID,
		CHANGE_CODE
	)
	select 
		t.ENTITY_CLEARANCE_SET_ID,
		t.RESOURCE_ID, 
		t.RELEASE_ID, 
		t.TERRITORIAL_RIGHTS_NOTES, 
		t.TERRITORIAL_RIGHTS_NOTES_FLAG, 
		t.COMPANY_ID,		
		'D'
	from
		DRA.EntityClearanceSet t 
	where
		t.ENTITY_CLEARANCE_SET_ID = @entityClearanceSetID
	
end;	


