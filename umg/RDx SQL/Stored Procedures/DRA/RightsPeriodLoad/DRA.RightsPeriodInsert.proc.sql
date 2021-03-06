﻿-- ============================================
-- Description:	Inserts records in DRA.RightsPeriod
-- =============================================
CREATE PROCEDURE DRA.RightsPeriodInsert 
AS
BEGIN
	insert into DRA.RightsPeriod
	select 
		l.*, 
		CHANGE_CODE = N'I', 
		CHANGE_DATE_TIME = getdate(),
		WORKFLOW_CODE = 'L'
	from 
		DRA.RightsPeriod t
		right outer join DRA.LoadRightsPeriod l on t.RIGHTS_PERIOD_ID = l.RIGHTS_PERIOD_ID
	where
		t.RIGHTS_PERIOD_ID is null
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.RightsPeriod', @@rowcount, 'I'
		
END
GO