﻿-- ============================================
-- Description:	Clears DRA clearance tables
-- =============================================
CREATE PROCEDURE [DRA].[ExtractLoadEntityClearanceTablesClear] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have unprocessed records (i.e. rows with workflow_code = 'E')
	select @existingJobRows = count(*) from DRA.ExtractDriverEntityClearance where WORKFLOW_CODE = 'E'
	if (@existingJobRows > 0)
		return;
		
	truncate table DRA.LoadEntityRejectionReason
END
GO