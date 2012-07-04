-- =============================================
-- Description:	Closes a batch in CPRS.LoadProductTerritoryRightDriver table.
-- =============================================
CREATE PROCEDURE [CPRS].[ProductTerritoryRightLoadBatchClose] 
AS
BEGIN
	update CPRS.LoadProductTerritoryRightDriver
		set WorkflowCode = 'C'
	where 
		WorkflowCode = 'T'
END
GO