-- ============================================
-- Description:	Closes a batch in R2.LoadReleaseResourceLinkDriver table.
-- =============================================
CREATE PROCEDURE [R2].[ReleaseResourceLinkCloseBatch] 
AS
BEGIN
	update R2.LoadReleaseResourceLinkDriver
		set [WORKFLOW_CODE] = 'C'
	where 
		[WORKFLOW_CODE] = 'T'
END
GO