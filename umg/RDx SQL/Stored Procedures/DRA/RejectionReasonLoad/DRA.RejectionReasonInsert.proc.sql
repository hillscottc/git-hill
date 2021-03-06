﻿-- ============================================
-- Description:	Inserts records in DRA.RejectionReason
-- =============================================
CREATE PROCEDURE DRA.RejectionReasonInsert 
AS
BEGIN
	insert into DRA.RejectionReason
	select 
		l.*, 
		CHANGE_CODE = N'I', 
		CHANGE_DATE_TIME = getdate(),
		WORKFLOW_CODE = 'L'
	from 
		DRA.RejectionReason t
		right outer join DRA.LoadRejectionReason l on t.REJECTION_REASON_ID = l.REJECTION_REASON_ID
	where
		t.REJECTION_REASON_ID is null
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.RejectionReason', @@rowcount, 'I'
		
END
GO