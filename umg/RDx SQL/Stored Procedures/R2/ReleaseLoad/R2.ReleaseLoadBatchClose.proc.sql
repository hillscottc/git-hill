-- ============================================
-- Description:	Closes a batch in R2.LoadReleaseDriver table.
-- =============================================
CREATE PROCEDURE [R2].[ReleaseLoadBatchClose] 
AS
BEGIN
	update R2.LoadReleaseDriver
		set [WORKFLOW_CODE] = 'C'
	where 
		[WORKFLOW_CODE] = 'T'
END
GO