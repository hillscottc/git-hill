﻿-- =============================================
-- Description:	Reserves all extracted records (E) in CPRS.LoadProductTerritoryRight for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE [CPRS].[ProductTerritoryRightLoadJobCreate] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have existing job already (i.e. rows with workflow_code = 'LT')
	select @existingJobRows = count(*) from CPRS.LoadProductTerritoryRight where WorkflowCode = 'LT'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	UPDATE CPRS.LoadProductTerritoryRight SET WorkflowCode = 'LT' WHERE WorkflowCode = 'E'
	return @@rowcount
END
GO