-- ============================================
-- Description:	Inserts records in DRA.ReleaseClearanceWorkflow
-- =============================================
CREATE PROCEDURE DRA.ReleaseClearanceWorkflowInsert 
AS
BEGIN
	insert into DRA.ReleaseClearanceWorkflow
	select 
		l.*, 
		CHANGE_CODE = N'I', 
		CHANGE_DATE_TIME = getdate(),
		WORKFLOW_CODE = 'L'
	from 
		DRA.ReleaseClearanceWorkflow t
		right outer join DRA.LoadReleaseClearanceWorkflow l 
			on t.RELEASE_ID = l.RELEASE_ID
	where
		t.RELEASE_ID is null
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.ReleaseClearanceWorkflow', @@rowcount, 'I'
		
END
GO