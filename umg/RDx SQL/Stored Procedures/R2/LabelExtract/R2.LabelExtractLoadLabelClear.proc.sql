-- ============================================
-- Description:	Deletes all records form R2.LoadLabel
-- =============================================
CREATE PROCEDURE R2.LabelExtractLoadLabelClear 
AS
	truncate table R2.LoadLabel
GO
