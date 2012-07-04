-- ============================================
-- Description:	Opens a batch of @batchSize for processing in R2.LoadResourceMedleyDriver table.
-- =============================================
CREATE PROCEDURE [R2].[ResourceMedleyOpenBatch] 
@batchSize int
AS
BEGIN
	update top(@batchSize) R2.LoadResourceMedleyDriver
		set [WORKFLOW_CODE] = 'T'
	where 
		[WORKFLOW_CODE] = 'L';

	return @@rowcount;		
END
GO