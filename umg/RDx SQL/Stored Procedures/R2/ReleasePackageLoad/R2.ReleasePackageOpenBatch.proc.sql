-- ============================================
-- Description:	Opens a batch of @batchSize for processing in R2.LoadReleasePackageDriver table.
-- =============================================
CREATE PROCEDURE [R2].[ReleasePackageOpenBatch] 
@batchSize int
AS
BEGIN
	update top(@batchSize) R2.LoadReleasePackageDriver
		set [WORKFLOW_CODE] = 'T'
	where 
		[WORKFLOW_CODE] = 'L';

	return @@rowcount;		
END
GO