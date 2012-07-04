-- ============================================
-- Description:	Inserts records in DRA.EntityRejectionReason
-- =============================================
CREATE PROCEDURE DRA.[EntityRejectionReasonLoadInsert] 
AS
BEGIN
	insert into DRA.EntityRejectionReason
	select 
		[ENTITY_CLEARANCE_ID] = l.[ENTITY_CLEARANCE_ID]
		,[REJECTION_REASON_ID] = l.[REJECTION_REASON_ID]

		,CHANGE_CODE = ld.CHANGE_CODE 
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		DRA.LoadEntityRejectionReason l 
		inner join DRA.LoadEntityRejectionReasonDriver ld 
			on l.ENTITY_CLEARANCE_ID = ld.ENTITY_CLEARANCE_ID and l.REJECTION_REASON_ID = ld.REJECTION_REASON_ID
	where 
		(ld.CHANGE_CODE = 'I' or ld.CHANGE_CODE = 'ID') and ld.[WORKFLOW_CODE] = 'T'
		and
		l.[WORKFLOW_CODE] = 'LT' 
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.EntityRejectionReason', @@rowcount, 'I'
		
END
