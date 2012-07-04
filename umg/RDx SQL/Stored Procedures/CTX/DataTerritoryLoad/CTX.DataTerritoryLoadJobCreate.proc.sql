-- ============================================
-- Description:	Reserves all extracted records (E) in CTX.LoadDataTerritory for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE CTX.[DataTerritoryLoadJobCreate] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have existing job already (i.e. rows with workflow_code = 'LT')
	select @existingJobRows = count(*) from CTX.LoadDataTerritory where WORKFLOW_CODE = 'LT'
	if (@existingJobRows > 0)
		return @existingJobRows;

	UPDATE CTX.LoadDataTerritory SET WORKFLOW_CODE = 'LT' WHERE WORKFLOW_CODE = 'E'
	return @@rowcount
END
GO