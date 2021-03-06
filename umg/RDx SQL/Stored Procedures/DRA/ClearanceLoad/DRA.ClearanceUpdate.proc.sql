﻿-- ============================================
-- Description:	Updates records in DRA.Clearance
-- =============================================
CREATE PROCEDURE DRA.ClearanceUpdate 
AS
BEGIN
	update DRA.Clearance
	set
		[CLEARANCE_ID] = l.[CLEARANCE_ID]
		,[NAME] = l.[NAME]
		,[ABBREVIATED_NAME] = l.[ABBREVIATED_NAME]
		,[SELECTION_TYPE] = l.[SELECTION_TYPE]
		,[USE_FLAG] = l.[USE_FLAG]

		,CHANGE_CODE = N'U'
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		DRA.Clearance t
		inner join DRA.LoadClearance l on t.CLEARANCE_ID = l.CLEARANCE_ID
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.Clearance', @@rowcount, 'U'
		
END
GO