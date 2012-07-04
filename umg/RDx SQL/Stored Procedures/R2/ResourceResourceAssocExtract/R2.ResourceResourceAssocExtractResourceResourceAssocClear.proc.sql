-- ============================================
-- Description:	Deletes all records form R2.LoadResourceResourceAssoc
-- =============================================
CREATE PROCEDURE R2.ResourceResourceAssocExtractLoadResourceResourceAssocClear 
AS
	truncate table R2.LoadResourceResourceAssoc
GO
