﻿-- ============================================
-- Description:	Updates records in DRA.ReleaseClearanceWorkflow
-- =============================================
CREATE PROCEDURE DRA.ReleaseClearanceWorkflowUpdate 
AS
BEGIN
	update DRA.ReleaseClearanceWorkflow
	set
		[RELEASE_ID] = l.[RELEASE_ID]
		,[STATUS_ID] = l.[STATUS_ID]
		,[STATUS_TIMESTAMP] = l.[STATUS_TIMESTAMP]
		,[EXTSYS_STATUS_ID] = l.[EXTSYS_STATUS_ID]
		,[EXTSYS_STATUS_TIMESTAMP] = l.[EXTSYS_STATUS_TIMESTAMP]

		,CHANGE_CODE = N'U'
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		DRA.ReleaseClearanceWorkflow t
		inner join DRA.LoadReleaseClearanceWorkflow l 
			on t.RELEASE_ID = l.RELEASE_ID
			
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.ReleaseClearanceWorkflow', @@rowcount, 'U'
			
END
GO