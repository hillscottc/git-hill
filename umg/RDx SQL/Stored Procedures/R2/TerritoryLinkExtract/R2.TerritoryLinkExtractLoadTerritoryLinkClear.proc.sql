﻿-- ============================================
-- Description:	Deletes all records form R2.LoadTerritoryLink
-- =============================================
CREATE PROCEDURE R2.TerritoryLinkExtractLoadTerritoryLinkClear 
AS
	truncate table R2.LoadTerritoryLink
GO
