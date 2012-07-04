-- =============================================
-- Description:	Reserves all extracted records (E) in CTX.LoadDataContract for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE [CTX].[DataContractLoadJobCreate] 
AS
BEGIN

	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have existing job already (i.e. rows with workflow_code = 'LT')
	select @existingJobRows = count(*) from CTX.LoadDataContract where WORKFLOW_CODE = 'LT'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	UPDATE CTX.LoadDataContract SET WORKFLOW_CODE = 'LT' WHERE WORKFLOW_CODE = 'E'
	return @@rowcount
END
GO