CREATE PROCEDURE R2.ProjectGetLastChangeDate(@date datetime output)
AS
	select @date = max(AUDIT_DATE_CHANGED) from R2.Project
RETURN 0;