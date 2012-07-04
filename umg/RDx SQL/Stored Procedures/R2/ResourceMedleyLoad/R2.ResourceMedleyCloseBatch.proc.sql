-- ============================================
-- Description:	Closes a batch in R2.LoadResourceMedleyDriver table.
-- =============================================
CREATE PROCEDURE [R2].[ResourceMedleyCloseBatch] 
AS
BEGIN
	update R2.LoadResourceMedleyDriver
		set [WORKFLOW_CODE] = 'C'
	where 
		[WORKFLOW_CODE] = 'T'
END
GO