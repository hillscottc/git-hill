-- ============================================
-- Description:	Closes a batch in DRA.LoadEntityCountryRightMVDriver table.
-- =============================================
CREATE PROCEDURE DRA.[EntityCountryRightMVLoadBatchClose] 
AS
BEGIN
	update DRA.LoadEntityCountryRightMVDriver
		set WORKFLOW_CODE = 'C'
	where 
		WORKFLOW_CODE = 'T'
END
GO