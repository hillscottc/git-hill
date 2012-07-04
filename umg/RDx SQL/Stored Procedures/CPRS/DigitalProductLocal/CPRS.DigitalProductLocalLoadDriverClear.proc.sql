-- =============================================
-- Description:	Deletes all records from the CPRS.LoadDigitalProductLocalDriver table
-- =============================================
CREATE PROCEDURE [CPRS].[DigitalProductLocalLoadDriverClear]
AS
begin
	declare @existingBatchRows int
	set @existingBatchRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingBatchRows = count(*) from CPRS.LoadDigitalProductLocalDriver where WorkflowCode = 'L'
	if (@existingBatchRows > 0)
		return;
		
	truncate table CPRS.LoadDigitalProductLocalDriver;
end	
