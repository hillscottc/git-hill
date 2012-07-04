-- ============================================
-- Description:	Updates talent name roles.
-- =============================================
CREATE PROCEDURE [R2].[TalentNameRolesCloseBatch] 
AS
BEGIN
	-- update the driver
	update R2.LoadTalentNameRolesDriver
		set [WORKFLOW_CODE] = 'C'
	where 
		[WORKFLOW_CODE] = 'T'
END
GO