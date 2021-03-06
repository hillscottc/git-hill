﻿-- ============================================
-- Description:	Deletes all records from the MP.LoadTrackTerritoryRightDriver table
-- =============================================
CREATE PROCEDURE [MP].[TrackTerritoryRightLoadDriverClear]
AS
begin
	declare @existingBatchRows int
	set @existingBatchRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingBatchRows = count(*) from  MP.LoadTrackTerritoryRightDriver where WorkflowCode = 'L'
	if (@existingBatchRows > 0)
		return;

	truncate table MP.LoadTrackTerritoryRightDriver;
end	
