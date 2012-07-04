-- ============================================
-- Description:	Deletes records form DRA.RejectionReason
-- =============================================
CREATE PROCEDURE DRA.RejectionReasonDelete 
AS
BEGIN
	update DRA.RejectionReason 
	set CHANGE_CODE = 'UD', CHANGE_DATE_TIME = getdate()
	from 
		DRA.RejectionReason t
		left outer join DRA.LoadRejectionReason l on t.REJECTION_REASON_ID = l.REJECTION_REASON_ID
	where
		l.REJECTION_REASON_ID is null
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.RejectionReason', @@rowcount, 'D'
		
END
GO
