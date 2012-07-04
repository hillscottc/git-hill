-- ============================================
-- Description:	Opens a batch of @batchSize for processing in R2.LoadResourceExcerptDriver table.
-- =============================================
CREATE PROCEDURE [R2].[ResourceExcerptOpenBatch] 
@batchSize int
AS
BEGIN
	update top(@batchSize) R2.LoadResourceExcerptDriver
		set [WORKFLOW_CODE] = 'T'
	where 
		[WORKFLOW_CODE] = 'L';

	return @@rowcount;		
END
GO