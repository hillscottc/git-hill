-- ============================================
-- Description:	Deletes all records form R2.LoadProject
-- =============================================
CREATE PROCEDURE R2.ProjectExtractLoadProjectClear 
AS
	truncate table R2.LoadProject
GO
