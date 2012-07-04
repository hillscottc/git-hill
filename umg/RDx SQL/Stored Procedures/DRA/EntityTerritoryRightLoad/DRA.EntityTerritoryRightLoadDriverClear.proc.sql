-- ============================================
-- Description:	Deletes all records from the DRA.LoadEntityTerritoryRightDriver table
-- =============================================
CREATE PROCEDURE DRA.[EntityTerritoryRightLoadDriverClear]
AS
begin
	declare @existingBatchRows int
	set @existingBatchRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingBatchRows = count(*) from  DRA.LoadEntityTerritoryRightDriver where WORKFLOW_CODE = 'L'
	if (@existingBatchRows > 0)
		return;

	truncate table DRA.LoadEntityTerritoryRightDriver;
end	
