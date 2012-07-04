-- ============================================
-- Description:	Opens a batch of @batchSize for processing in R2.LoadTalentDriver table.
-- =============================================
CREATE PROCEDURE [R2].[TalentOpenBatch] 
@batchSize int
AS
BEGIN
	update top(@batchSize) R2.LoadTalentDriver
		set [WORKFLOW_CODE] = 'T'
	where 
		[WORKFLOW_CODE] = 'L';

	return @@rowcount;		
END
GO