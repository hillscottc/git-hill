CREATE PROCEDURE [CPRS].[DigitalProductLoadDriverClear]
AS
begin
	declare @existingBatchRows int
	set @existingBatchRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingBatchRows = count(*) from CPRS.LoadDigitalProductDriver where WorkflowCode = 'L'
	if (@existingBatchRows > 0)
		return;
		
	truncate table CPRS.LoadDigitalProductDriver;
end	
