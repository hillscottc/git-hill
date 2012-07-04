-- ============================================
-- Description:	Reserves all extracted records (E) in CTX.LoadDataRepertoire for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE CTX.[DataRepertoireLoadJobCreate] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have existing job already (i.e. rows with workflow_code = 'LT')
	select @existingJobRows = count(*) from CTX.LoadDataRepertoire where WORKFLOW_CODE = 'LT'
	if (@existingJobRows > 0)
		return @existingJobRows;

	UPDATE CTX.LoadDataRepertoire SET WORKFLOW_CODE = 'LT' WHERE WORKFLOW_CODE = 'E'
	return @@rowcount
END
GO