﻿-- ============================================
-- Description:	Closes a batch in DRA.LoadEntityClearanceSetDriver table.
-- =============================================
CREATE PROCEDURE DRA.[EntityClearanceSetLoadBatchClose] 
AS
BEGIN
	update DRA.LoadEntityClearanceSetDriver
		set [WORKFLOW_CODE] = 'C'
	where 
		[WORKFLOW_CODE] = 'T'
END
GO