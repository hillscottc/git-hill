﻿-- =============================================
-- Description:	Deletes all records from the CPRS.LoadPhysicalProductDriver table
-- =============================================
CREATE PROCEDURE [CPRS].[PhysicalProductLoadDriverClear]
AS
begin
	declare @existingBatchRows int
	set @existingBatchRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingBatchRows = count(*) from CPRS.LoadPhysicalProductDriver where WorkflowCode = 'L'
	if (@existingBatchRows > 0)
		return;
		
	truncate table CPRS.LoadPhysicalProductDriver;
end	
