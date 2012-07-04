﻿-- ============================================
-- Description:	Closes a batch in R2.LoadProjectDriver table.
-- =============================================
CREATE PROCEDURE [R2].[ProjectCloseBatch] 
AS
BEGIN
	update R2.LoadProjectDriver
		set [WORKFLOW_CODE] = 'C'
	where 
		[WORKFLOW_CODE] = 'T'
END
GO