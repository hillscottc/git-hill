-- ============================================
-- Description:	Reserves all extracted records (E) in R2.LoadResourceLocal for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE [R2].[ResourceLoadJobCreateLocal] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have existing job already (i.e. rows with workflow_code = 'LT')
	select @existingJobRows = count(*) from R2.LoadResourceLocal where WORKFLOW_CODE = 'LT'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	UPDATE R2.LoadResourceLocal SET WORKFLOW_CODE = 'LT' WHERE WORKFLOW_CODE = 'E'
	return @@rowcount
END
GO