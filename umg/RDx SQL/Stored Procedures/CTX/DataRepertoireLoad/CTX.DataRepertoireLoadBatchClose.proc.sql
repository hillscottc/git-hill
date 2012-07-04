-- ============================================
-- Description:	Closes a batch in CTX.LoadDataRepertoireDriver table.
-- =============================================
CREATE PROCEDURE CTX.[DataRepertoireLoadBatchClose] 
AS
BEGIN
	update CTX.LoadDataRepertoireDriver
		set WORKFLOW_CODE = 'C'
	where 
		WORKFLOW_CODE = 'T'
END
GO