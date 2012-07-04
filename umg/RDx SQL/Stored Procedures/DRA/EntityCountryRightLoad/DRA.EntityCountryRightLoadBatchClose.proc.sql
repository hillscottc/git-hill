-- ============================================
-- Description:	Closes a batch in DRA.LoadEntityCountryRightDriver table.
-- =============================================
CREATE PROCEDURE DRA.[EntityCountryRightLoadBatchClose] 
AS
BEGIN
	update DRA.LoadEntityCountryRightDriver
		set WORKFLOW_CODE = 'C'
	where 
		WORKFLOW_CODE = 'T'
END
GO