-- ============================================
-- Description:	Deletes all records form R2.LoadControl
-- =============================================
CREATE PROCEDURE R2.ControlExtractLoadControlClear 
AS
	truncate table R2.LoadControl
GO
