-- ============================================
-- Description:	Deletes all records form R2.LoadRole
-- =============================================
CREATE PROCEDURE R2.RoleExtractLoadRoleClear 
AS
	truncate table R2.LoadRole
GO
