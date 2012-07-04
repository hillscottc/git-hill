-- ============================================
-- Description:	Deletes all records form R2.LoadConfigResourceTypeLink
-- =============================================
CREATE PROCEDURE R2.ConfigResourceTypeLinkExtractLoadConfigResourceTypeLinkClear 
AS
	truncate table R2.LoadConfigResourceTypeLink
GO
