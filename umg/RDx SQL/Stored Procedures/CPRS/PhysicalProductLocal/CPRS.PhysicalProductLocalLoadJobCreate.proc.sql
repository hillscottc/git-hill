-- =============================================
-- Description:	Reserves all extracted records (E) in CPRS.LoadPhysicalProductLocal for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE [CPRS].[PhysicalProductLocalLoadJobCreate] 
AS
BEGIN

	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have existing job already (i.e. rows with workflow_code = 'LT')
	select @existingJobRows = count(*) from CPRS.LoadPhysicalProductLocal where WorkflowCode = 'LT'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	UPDATE CPRS.LoadPhysicalProductLocal SET WorkflowCode = 'LT' WHERE WorkflowCode = 'E'
	return @@rowcount
END
GO