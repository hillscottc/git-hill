-- ============================================
-- Description:	Closes a batch in R2.LoadReleasePackageDriver table.
-- =============================================
CREATE PROCEDURE [R2].[ReleasePackageCloseBatch] 
AS
BEGIN
	update R2.LoadReleasePackageDriver
		set [WORKFLOW_CODE] = 'C'
	where 
		[WORKFLOW_CODE] = 'T'
END
GO