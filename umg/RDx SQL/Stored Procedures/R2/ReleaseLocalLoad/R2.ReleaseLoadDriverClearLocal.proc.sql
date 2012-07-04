-- ============================================
-- Description:	Deletes all records from the R2.LoadReleaseLocalDriver table
-- =============================================
CREATE PROCEDURE [R2].[ReleaseLoadDriverClearLocal]
AS
begin
	declare @existingBatchRows int
	set @existingBatchRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingBatchRows = count(*) from R2.LoadReleaseLocalDriver where [WORKFLOW_CODE] = 'L'
	if (@existingBatchRows > 0)
		return;
		
	truncate table R2.LoadReleaseLocalDriver;
end	
