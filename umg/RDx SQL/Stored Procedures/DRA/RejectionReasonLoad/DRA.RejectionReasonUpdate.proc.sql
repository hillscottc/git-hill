﻿-- ============================================
-- Description:	Updates records in DRA.RejectionReason
-- =============================================
CREATE PROCEDURE DRA.RejectionReasonUpdate 
AS
BEGIN
	update DRA.RejectionReason
	set
		[REJECTION_REASON_ID] = l.[REJECTION_REASON_ID]
		,[NAME] = l.[NAME]
		,[SEQUENCE_NO] = l.[SEQUENCE_NO]

		,CHANGE_CODE = N'U'
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		DRA.RejectionReason t
		inner join DRA.LoadRejectionReason l on t.REJECTION_REASON_ID = l.REJECTION_REASON_ID
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.RejectionReason', @@rowcount, 'U'
		
END
GO