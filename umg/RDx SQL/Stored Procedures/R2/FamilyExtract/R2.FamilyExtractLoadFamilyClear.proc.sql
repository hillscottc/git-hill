-- ============================================
-- Description:	Deletes all records form R2.LoadFamily
-- =============================================
CREATE PROCEDURE R2.FamilyExtractLoadFamilyClear 
AS
	truncate table R2.LoadFamily
GO
