-- ============================================
-- Description:	Closes a batch in R2.LoadResourceExcerptDriver table.
-- =============================================
CREATE PROCEDURE [R2].[ResourceExcerptCloseBatch] 
AS
BEGIN
	update R2.LoadResourceExcerptDriver
		set [WORKFLOW_CODE] = 'C'
	where 
		[WORKFLOW_CODE] = 'T'
END
GO