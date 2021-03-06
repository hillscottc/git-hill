﻿-- ============================================
-- Description:	Reserves all extracted records (E) in MP.LoadRelease for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE [MP].[ReleaseLoadJobCreate] 
AS
BEGIN

	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have existing job already (i.e. rows with workflow_code = 'LT')
	select @existingJobRows = count(*) from MP.LoadRelease where WorkflowCode = 'LT'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	UPDATE MP.LoadRelease SET WorkflowCode = 'LT' WHERE WorkflowCode = 'E'
	return @@rowcount
END
GO