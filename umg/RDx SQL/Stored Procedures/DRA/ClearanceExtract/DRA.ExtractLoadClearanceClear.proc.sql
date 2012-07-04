-- ============================================
-- Description:	Deletes all records form DRA.LoadClearance
-- =============================================
CREATE PROCEDURE DRA.ExtractLoadClearanceClear 
AS
	truncate table DRA.LoadClearance
GO
