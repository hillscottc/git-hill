﻿-- =============================================
-- Description:	Deletes all records from the CPRS.LoadPhysicalProductLocalDriver table
-- =============================================
CREATE PROCEDURE [CPRS].[PhysicalProductLocalLoadDriverClear]
AS
begin
	declare @existingBatchRows int
	set @existingBatchRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingBatchRows = count(*) from CPRS.LoadPhysicalProductLocalDriver where WorkflowCode = 'L'
	if (@existingBatchRows > 0)
		return;
		
	truncate table CPRS.LoadPhysicalProductLocalDriver;
end	
