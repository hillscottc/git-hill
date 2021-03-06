﻿-- ============================================
-- Description:	Reserves all extracted records (E) in DRA.LoadEntityClearanceSet for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE DRA.[EntityClearanceSetLoadJobCreate] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have existing job already (i.e. rows with workflow_code = 'LT')
	select @existingJobRows = count(*) from DRA.LoadEntityClearanceSet where WORKFLOW_CODE = 'LT'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	UPDATE DRA.LoadEntityClearanceSet SET WORKFLOW_CODE = 'LT' WHERE WORKFLOW_CODE = 'E'
	return @@rowcount
END
GO