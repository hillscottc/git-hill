-- ============================================
-- Description:	Deletes all records form CTX.LoadMetaProperty
-- =============================================
CREATE PROCEDURE CTX.ExtractLoadMetaPropertyClear 
AS
	truncate table CTX.LoadMetaProperty
GO
