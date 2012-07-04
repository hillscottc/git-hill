﻿-- ============================================
-- Description:	Closes a batch in DRA.LoadEntityRejectionReasonDriver table.
-- =============================================
CREATE PROCEDURE DRA.[EntityRejectionReasonLoadBatchClose] 
AS
BEGIN
	update DRA.LoadEntityRejectionReasonDriver
		set WORKFLOW_CODE = 'C'
	where 
		WORKFLOW_CODE = 'T'
END
GO