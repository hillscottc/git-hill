-- ============================================
-- Description:	Deletes records form DRA.ReleaseClearanceWorkflow
-- =============================================
CREATE PROCEDURE DRA.ReleaseClearanceWorkflowDelete 
AS
BEGIN
	update DRA.ReleaseClearanceWorkflow 
	set CHANGE_CODE = 'UD', CHANGE_DATE_TIME = getdate()
	from 
		DRA.ReleaseClearanceWorkflow t
		left outer join DRA.LoadReleaseClearanceWorkflow l 
			on t.RELEASE_ID = l.RELEASE_ID
	where
		l.RELEASE_ID is null
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.ReleaseClearanceWorkflow', @@rowcount, 'D'
		
END
GO
