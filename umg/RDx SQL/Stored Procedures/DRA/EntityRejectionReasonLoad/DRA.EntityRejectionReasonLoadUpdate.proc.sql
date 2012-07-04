-- ============================================
-- Description:	Updates records in DRA.EntityRejectionReason
-- =============================================
CREATE PROCEDURE DRA.EntityRejectionReasonLoadUpdate
AS
BEGIN
	update DRA.EntityRejectionReason
	set
		[ENTITY_CLEARANCE_ID] = l.[ENTITY_CLEARANCE_ID]
		,[REJECTION_REASON_ID] = l.[REJECTION_REASON_ID]
		
		,CHANGE_CODE = ld.CHANGE_CODE
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		DRA.EntityRejectionReason t
		inner join DRA.LoadEntityRejectionReason l 
			on t.ENTITY_CLEARANCE_ID = l.ENTITY_CLEARANCE_ID and t.REJECTION_REASON_ID = l.REJECTION_REASON_ID
		inner join DRA.LoadEntityRejectionReasonDriver ld 
			on l.ENTITY_CLEARANCE_ID = ld.ENTITY_CLEARANCE_ID and l.REJECTION_REASON_ID = ld.REJECTION_REASON_ID
	where
		(ld.CHANGE_CODE = 'U' or ld.CHANGE_CODE = 'UD') and ld.WORKFLOW_CODE = 'T'
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.EntityRejectionReason', @@rowcount, 'U'
		
END
