-- ============================================
-- Description:	Deletes all records from the MP.LoadReleaseDriver table
-- =============================================
CREATE PROCEDURE [MP].[ReleaseLoadDriverClear]
AS
begin

	declare @existingBatchRows int
	set @existingBatchRows = 0

	-- see if we have loaded records (i.e. rows with WorkflowCode = 'L')
	select @existingBatchRows = count(*) from  MP.LoadReleaseDriver where WorkflowCode = 'L'
	if (@existingBatchRows > 0)
		return;
		
	truncate table MP.LoadReleaseDriver;
end	
