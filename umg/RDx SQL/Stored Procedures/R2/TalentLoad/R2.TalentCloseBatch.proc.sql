-- ============================================
-- Description:	Closes a batch in R2.LoadTalentDriver table.
-- =============================================
CREATE PROCEDURE [R2].[TalentCloseBatch] 
AS
BEGIN
	update R2.LoadTalentDriver
		set [WORKFLOW_CODE] = 'C'
	where 
		[WORKFLOW_CODE] = 'T'
END
GO