﻿-- ============================================
-- Description:	Closes a batch in R2.LoadResourceResourceAssocDriver table.
-- =============================================
CREATE PROCEDURE [R2].[ResourceResourceAssocCloseBatch] 
AS
BEGIN
	update R2.LoadResourceResourceAssocDriver
		set [WORKFLOW_CODE] = 'C'
	where 
		[WORKFLOW_CODE] = 'T'
END
GO