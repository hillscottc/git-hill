-- =============================================
-- Description:	Closes a batch in CTX.LoadDataContractDriver table.
-- =============================================
CREATE PROCEDURE [CTX].[DataContractLoadBatchClose] 
AS
BEGIN
	update CTX.LoadDataContractDriver
		set [WORKFLOW_CODE] = 'C'
	where 
		[WORKFLOW_CODE] = 'T'
END
GO