-- ============================================
-- Description:	Deletes all records form R2.LoadDivision
-- =============================================
CREATE PROCEDURE R2.DivisionExtractLoadDivisionClear 
AS
	truncate table R2.LoadDivision
GO
