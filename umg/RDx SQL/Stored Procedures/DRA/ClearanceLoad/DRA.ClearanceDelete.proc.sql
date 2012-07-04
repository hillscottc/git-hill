-- ============================================
-- Description:	Deletes records form DRA.Clearance
-- =============================================
CREATE PROCEDURE DRA.ClearanceDelete 
AS
BEGIN
	update DRA.Clearance 
	set CHANGE_CODE = 'UD', CHANGE_DATE_TIME = getdate()
	from 
		DRA.Clearance t
		left outer join DRA.LoadClearance l on t.CLEARANCE_ID = l.CLEARANCE_ID
	where
		l.CLEARANCE_ID is null
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.Clearance', @@rowcount, 'D'
		
END
GO
