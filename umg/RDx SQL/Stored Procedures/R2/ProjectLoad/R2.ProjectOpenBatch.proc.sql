-- ============================================
-- Description:	Opens a batch of @batchSize for processing in R2.LoadProjectDriver table.
-- =============================================
CREATE PROCEDURE [R2].[ProjectOpenBatch] 
@batchSize int
AS
BEGIN
	update top(@batchSize) R2.LoadProjectDriver
		set [WORKFLOW_CODE] = 'T'
	where 
		[WORKFLOW_CODE] = 'L';

	return @@rowcount;		
END
GO