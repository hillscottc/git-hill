-- ============================================
-- Description:	Reserves all extracted records (E) in MP.LoadTrackTerritoryRight for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE [MP].[TrackTerritoryRightLoadJobCreate] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have existing job already (i.e. rows with workflow_code = 'LT')
	select @existingJobRows = count(*) from MP.LoadTrackTerritoryRight where WorkflowCode = 'LT'
	if (@existingJobRows > 0)
		return @existingJobRows;

	UPDATE MP.LoadTrackTerritoryRight SET WorkflowCode = 'LT' WHERE WorkflowCode = 'E'
	return @@rowcount
END
GO