-- ============================================
-- Description:	Closes a batch in R2.LoadResourceDriver table.
-- =============================================
CREATE PROCEDURE [R2].[ResourceLoadBatchClose] 
AS
BEGIN
	update R2.LoadResourceDriver
		set [WORKFLOW_CODE] = 'C'
	where 
		[WORKFLOW_CODE] = 'T'
END
GO