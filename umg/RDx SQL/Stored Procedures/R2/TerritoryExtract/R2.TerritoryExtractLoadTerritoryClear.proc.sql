-- ============================================
-- Description:	Deletes all records form R2.LoadTerritory
-- =============================================
CREATE PROCEDURE R2.TerritoryExtractLoadTerritoryClear 
AS
	truncate table R2.LoadTerritory
GO
