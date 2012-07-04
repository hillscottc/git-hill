-- ============================================
-- Description:	Closes a batch in CTX.LoadDataTerritoryDriver table.
-- =============================================
CREATE PROCEDURE CTX.[DataTerritoryLoadBatchClose] 
AS
BEGIN
	update CTX.LoadDataTerritoryDriver
		set WORKFLOW_CODE = 'C'
	where 
		WORKFLOW_CODE = 'T'
END
GO