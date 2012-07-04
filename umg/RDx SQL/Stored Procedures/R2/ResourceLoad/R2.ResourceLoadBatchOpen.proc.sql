-- ============================================
-- Description:	Opens a batch of @batchSize for processing in R2.LoadResourceDriver table.
-- =============================================
CREATE PROCEDURE [R2].[ResourceLoadBatchOpen] 
@batchSize int
AS
BEGIN

	declare @existingBatchRows int
	set @existingBatchRows = 0
	
	-- see if we have an open transform batch (i.e. rows with workflow_code = 'T')
	select @existingBatchRows = count(*) from R2.LoadResourceDriver where [WORKFLOW_CODE] = 'T'
	if (@existingBatchRows > 0)
		return @existingBatchRows;

	-- create a new transfrom batch
	update top(@batchSize) R2.LoadResourceDriver
		set [WORKFLOW_CODE] = 'T'
	where 
		[WORKFLOW_CODE] = 'L';

	return @@rowcount;		
END
GO