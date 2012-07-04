-- ============================================
-- Description:	Deletes all records form R2.LoadTalentName
-- =============================================
CREATE PROCEDURE R2.TalentNameExtractLoadTalentNameClear 
AS
	truncate table R2.LoadTalentName
GO
