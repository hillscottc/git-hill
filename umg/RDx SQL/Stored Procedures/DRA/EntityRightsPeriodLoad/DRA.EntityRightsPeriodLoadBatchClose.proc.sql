-- ============================================
-- Description:	Closes a batch in DRA.LoadEntityRightsPeriodDriver table.
-- =============================================
CREATE PROCEDURE DRA.[EntityRightsPeriodLoadBatchClose] 
AS
BEGIN
	update DRA.LoadEntityRightsPeriodDriver
		set WORKFLOW_CODE = 'C'
	where 
		WORKFLOW_CODE = 'T'
END
GO