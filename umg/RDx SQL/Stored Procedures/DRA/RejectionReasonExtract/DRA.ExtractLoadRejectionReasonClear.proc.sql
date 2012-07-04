-- ============================================
-- Description:	Deletes all records form DRA.LoadRejectionReason
-- =============================================
CREATE PROCEDURE DRA.ExtractLoadRejectionReasonClear 
AS
	truncate table DRA.LoadRejectionReason
GO
