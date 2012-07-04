-- ============================================
-- Description:	Deletes all records form R2.LoadConfig
-- =============================================
CREATE PROCEDURE R2.ConfigExtractLoadConfigClear 
AS
	truncate table R2.LoadConfig
GO
