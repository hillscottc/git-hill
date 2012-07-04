-- ============================================
-- Description:	Closes a batch in DRA.LoadEntityClearanceDriver table.
-- =============================================
CREATE PROCEDURE DRA.[EntityClearanceLoadBatchClose] 
AS
BEGIN
	update DRA.LoadEntityClearanceDriver
		set WORKFLOW_CODE = 'C'
	where 
		WORKFLOW_CODE = 'T'
END
GO