-- ============================================
-- Description:	Deletes all records form DRA.LoadClearance
-- =============================================
CREATE PROCEDURE DRA.ExtractLoadReleaseClearanceWorkflowClear 
AS
	truncate table DRA.LoadReleaseClearanceWorkflow
GO
