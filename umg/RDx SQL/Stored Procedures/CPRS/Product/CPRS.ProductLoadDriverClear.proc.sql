﻿-- =============================================
-- Description:	Deletes all records from the CPRS.LoadProductDriver table
-- =============================================
CREATE PROCEDURE [CPRS].[ProductLoadDriverClear]
AS
begin
	declare @existingBatchRows int
	set @existingBatchRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingBatchRows = count(*) from CPRS.LoadProductDriver where WorkflowCode = 'L'
	if (@existingBatchRows > 0)
		return;
		
	truncate table CPRS.LoadProductDriver;
end	
