-- ============================================
-- Description:	Opens a batch of @batchSize for processing in MP.LoadTrackTerritoryRightDriver table.
-- =============================================
CREATE PROCEDURE [MP].[TrackTerritoryRightLoadBatchOpen] 
@batchSize int
AS
BEGIN

	declare @existingBatchRows int
	set @existingBatchRows = 0
	
	-- see if we have an open transform batch (i.e. rows with workflow_code = 'T')
	select @existingBatchRows = count(*) from MP.LoadTrackTerritoryRightDriver where WorkflowCode = 'T'
	if (@existingBatchRows > 0)
		return @existingBatchRows;

	-- create a new transfrom batch
	update top(@batchSize) MP.LoadTrackTerritoryRightDriver
		set WorkflowCode = 'T'
	where 
		WorkflowCode = 'L';

	return @@rowcount;		
END
GO