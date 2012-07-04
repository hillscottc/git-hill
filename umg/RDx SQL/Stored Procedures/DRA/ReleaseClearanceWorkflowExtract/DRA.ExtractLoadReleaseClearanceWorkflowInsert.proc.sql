-- ============================================
-- Description:	Load records from DRA.CLEARANCE into DRA.LoadClerance
-- =============================================
CREATE PROCEDURE DRA.ExtractLoadReleaseClearanceWorkflowInsert
AS
	insert into DRA.LoadReleaseClearanceWorkflow
	select * 
	from openquery 
	(DRA, 
	'
		SELECT 
			R.RELEASE_ID, 
			R.STATUS_ID, 
			R.STATUS_TIMESTAMP, 
			R.EXTSYS_STATUS_ID, 
			R.EXTSYS_STATUS_TIMESTAMP
		FROM 
			DRA.RELEASE_CLEARANCE_WORKFLOW R
	');


