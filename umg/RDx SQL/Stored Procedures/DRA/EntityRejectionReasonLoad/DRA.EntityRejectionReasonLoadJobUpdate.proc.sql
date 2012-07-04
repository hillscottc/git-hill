-- ============================================
-- Description:	
-- =============================================
CREATE PROCEDURE DRA.[EntityRejectionReasonLoadJobUpdate] 
AS
BEGIN
	UPDATE DRA.LoadEntityRejectionReason
	SET WORKFLOW_CODE = 'C' 
	from DRA.LoadEntityRejectionReason l 
		inner join DRA.LoadEntityRejectionReasonDriver ld 
			on l.ENTITY_CLEARANCE_ID = ld.ENTITY_CLEARANCE_ID and l.REJECTION_REASON_ID = ld.REJECTION_REASON_ID
	where 
		l.WORKFLOW_CODE = 'LT'
		and
		ld.WORKFLOW_CODE = 'T'
END
GO