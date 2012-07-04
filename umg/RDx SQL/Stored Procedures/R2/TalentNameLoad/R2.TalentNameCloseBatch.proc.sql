-- ============================================
-- Description:	Closes a batch in R2.LoadTalentNameDriver table.
-- =============================================
CREATE PROCEDURE [R2].[TalentNameCloseBatch] 
AS
BEGIN
	update R2.LoadTalentNameDriver
		set [WORKFLOW_CODE] = 'C'
	where 
		[WORKFLOW_CODE] = 'T'
END
GO