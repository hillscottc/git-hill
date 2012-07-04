-- ============================================
-- Description:	Loads records from DRA.ENTITY_REJECTION_REASON into DRA.LoadEntityRejectionReason
-- =============================================
CREATE PROCEDURE DRA.ExtractLoadEntityRejectionReasonInsert(@entityClearanceID numeric (38, 0))
AS
begin
	insert into DRA.LoadEntityRejectionReason
	(
		ENTITY_CLEARANCE_ID, 
		REJECTION_REASON_ID
	)
	execute 
	('
		SELECT 
			E.ENTITY_CLEARANCE_ID, 
			E.REJECTION_REASON_ID
		FROM 
			DRA.ENTITY_REJECTION_REASON E
		WHERE
			E.ENTITY_CLEARANCE_ID = ' + @entityClearanceID
	) at DRA
	
	if (@@rowcount > 0)
		return;
	
	-- If @@rowcount is 0 there are no records in the source table.
	-- Now go to our own table and schedule any existing records for deletion
	insert into DRA.LoadEntityRejectionReason
	(
		ENTITY_CLEARANCE_ID, 
		REJECTION_REASON_ID, 
		CHANGE_CODE
	)
	select 
		t.ENTITY_CLEARANCE_ID,
		t.REJECTION_REASON_ID, 
		'D'
	from
		DRA.EntityRejectionReason t 
	where
		t.ENTITY_CLEARANCE_ID = @entityClearanceID	
end;	


