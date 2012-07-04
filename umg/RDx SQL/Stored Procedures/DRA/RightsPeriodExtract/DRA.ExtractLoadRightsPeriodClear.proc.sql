-- ============================================
-- Description:	Deletes all records form DRA.LoadRightsPeriod
-- =============================================
CREATE PROCEDURE DRA.ExtractLoadRightsPeriodClear 
AS
	truncate table DRA.LoadRightsPeriod
GO
