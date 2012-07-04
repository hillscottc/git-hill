-- ============================================
-- Description:	Closes a batch in R2.LoadReleaseLocalDriver table.
-- =============================================
CREATE PROCEDURE [R2].[ReleaseLoadBatchCloseLocal] 
AS
BEGIN
	update R2.LoadReleaseLocalDriver
		set [WORKFLOW_CODE] = 'C'
	where 
		[WORKFLOW_CODE] = 'T'
END
GO