﻿-- ============================================
-- Description:	Deletes all records from the CTX.LoadDataTerritoryDriver table
-- =============================================
CREATE PROCEDURE CTX.[DataTerritoryLoadDriverClear]
AS
begin
	declare @existingBatchRows int
	set @existingBatchRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingBatchRows = count(*) from  CTX.LoadDataTerritoryDriver where WORKFLOW_CODE = 'L'
	if (@existingBatchRows > 0)
		return;

	truncate table CTX.LoadDataTerritoryDriver;
end	
