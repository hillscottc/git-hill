﻿-- =============================================
-- Description:	Opens a batch of @batchSize for processing in CPRS.LoadPhysicalProductLocalDriver table.
-- =============================================
CREATE PROCEDURE [CPRS].[PhysicalProductLocalLoadBatchOpen] 
@batchSize int
AS
BEGIN

	declare @existingBatchRows int
	set @existingBatchRows = 0
	
	-- see if we have an open transform batch (i.e. rows with workflow_code = 'T')
	select @existingBatchRows = count(*) from CPRS.LoadPhysicalProductLocalDriver where WorkflowCode = 'T'
	if (@existingBatchRows > 0)
		return @existingBatchRows;

	-- create a new transfrom batch
	update top(@batchSize) CPRS.LoadPhysicalProductLocalDriver
		set WorkflowCode = 'T'
	where 
		WorkflowCode = 'L';

	return @@rowcount;		
END
GO