﻿-- ============================================
-- Description:	Updates records in DRA.RightsPeriod
-- =============================================
CREATE PROCEDURE DRA.RightsPeriodUpdate 
AS
BEGIN
	update DRA.RightsPeriod
	set
		[RIGHTS_PERIOD_ID] = l.[RIGHTS_PERIOD_ID]
		,[DESCRIPTION] = l.[DESCRIPTION]
		
		,CHANGE_CODE = N'U'
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		DRA.RightsPeriod t
		inner join DRA.LoadRightsPeriod l on t.RIGHTS_PERIOD_ID = l.RIGHTS_PERIOD_ID
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.RightsPeriod', @@rowcount, 'U'
END
GO