-- ============================================
-- Description:	Deletes all records form R2.LoadReleaseResourceLink
-- =============================================
CREATE PROCEDURE R2.ReleaseResourceLinkExtractLoadReleaseResourceLinkClear 
AS
	truncate table R2.LoadReleaseResourceLink
GO
