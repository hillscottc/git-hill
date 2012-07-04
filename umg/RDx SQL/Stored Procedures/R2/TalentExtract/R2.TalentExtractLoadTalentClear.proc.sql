-- ============================================
-- Description:	Deletes all records form R2.LoadTalent
-- =============================================
CREATE PROCEDURE R2.TalentExtractLoadTalentClear 
AS
	truncate table R2.LoadTalent
GO
