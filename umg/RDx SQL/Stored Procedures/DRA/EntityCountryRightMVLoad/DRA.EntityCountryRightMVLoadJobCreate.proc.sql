﻿-- ============================================
-- Description:	Reserves all extracted records (E) in DRA.LoadEntityCountryRightMV for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE DRA.[EntityCountryRightMVLoadJobCreate] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have existing job already (i.e. rows with workflow_code = 'LT')
	select @existingJobRows = count(*) from DRA.LoadEntityCountryRightMV where WORKFLOW_CODE = 'LT'
	if (@existingJobRows > 0)
		return @existingJobRows;

	UPDATE DRA.LoadEntityCountryRightMV SET WORKFLOW_CODE = 'LT' WHERE WORKFLOW_CODE = 'E'
	return @@rowcount
END
GO