-- ============================================
-- Description:	Deletes all records from the R2.LoadResourceLocalDriver table
-- =============================================
CREATE PROCEDURE [R2].[ResourceLoadDriverClearLocal]
AS
begin

	declare @existingBatchRows int
	set @existingBatchRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingBatchRows = count(*) from R2.LoadResourceLocalDriver where [WORKFLOW_CODE] = 'L'
	if (@existingBatchRows > 0)
		return;
		
	truncate table R2.LoadResourceLocalDriver;
end	
