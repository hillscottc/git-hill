-- ============================================
-- Description:	Deletes all records form R2.LoadTerritoryArea
-- =============================================
CREATE PROCEDURE R2.TerritoryAreaExtractLoadTerritoryAreaClear 
AS
	truncate table R2.LoadTerritoryArea
GO
