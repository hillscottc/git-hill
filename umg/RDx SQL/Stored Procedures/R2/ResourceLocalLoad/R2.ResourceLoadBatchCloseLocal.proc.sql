﻿-- ============================================
-- Description:	Closes a batch in R2.LoadResourceLocalDriver table.
-- =============================================
CREATE PROCEDURE [R2].[ResourceLoadBatchCloseLocal] 
AS
BEGIN
	update R2.LoadResourceLocalDriver
		set [WORKFLOW_CODE] = 'C'
	where 
		[WORKFLOW_CODE] = 'T'
END
GO