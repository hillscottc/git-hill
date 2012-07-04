-- ============================================
-- Description:	Deletes all records from the DRA.LoadEntityCountryRightMVDriver table
-- =============================================
CREATE PROCEDURE DRA.[EntityCountryRightMVLoadDriverClear]
AS
begin
	declare @existingBatchRows int
	set @existingBatchRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingBatchRows = count(*) from  DRA.LoadEntityCountryRightMVDriver where WORKFLOW_CODE = 'L'
	if (@existingBatchRows > 0)
		return;

	truncate table DRA.LoadEntityCountryRightMVDriver;
end	
