﻿-- ============================================
-- Description:	Reserves all extracted records (E) in DRA.LoadEntityRejectionReason for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE DRA.[EntityRejectionReasonLoadJobCreate] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have existing job already (i.e. rows with workflow_code = 'LT')
	select @existingJobRows = count(*) from DRA.LoadEntityRejectionReason where WORKFLOW_CODE = 'LT'
	if (@existingJobRows > 0)
		return @existingJobRows;

	UPDATE DRA.LoadEntityRejectionReason SET WORKFLOW_CODE = 'LT' WHERE WORKFLOW_CODE = 'E'
	return @@rowcount
END
GO