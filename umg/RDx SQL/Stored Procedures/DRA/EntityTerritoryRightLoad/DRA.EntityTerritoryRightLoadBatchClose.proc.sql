-- ============================================
-- Description:	Closes a batch in DRA.LoadEntityTerritoryRightDriver table.
-- =============================================
CREATE PROCEDURE DRA.[EntityTerritoryRightLoadBatchClose] 
AS
BEGIN
	update DRA.LoadEntityTerritoryRightDriver
		set WORKFLOW_CODE = 'C'
	where 
		WORKFLOW_CODE = 'T'
END
GO