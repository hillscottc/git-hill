-- ============================================
-- Description:	Deletes records form DRA.RightsPeriod
-- =============================================
CREATE PROCEDURE DRA.RightsPeriodDelete 
AS
BEGIN
	update DRA.RightsPeriod 
	set CHANGE_CODE = 'UD', CHANGE_DATE_TIME = getdate()
	from 
		DRA.RightsPeriod t
		left outer join DRA.LoadRightsPeriod l on t.RIGHTS_PERIOD_ID = l.RIGHTS_PERIOD_ID
	where
		l.RIGHTS_PERIOD_ID is null
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.RightsPeriod', @@rowcount, 'D'
		
END
GO
