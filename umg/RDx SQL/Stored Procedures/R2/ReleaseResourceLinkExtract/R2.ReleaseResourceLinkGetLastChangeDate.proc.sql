CREATE PROCEDURE R2.ReleaseResourceLinkGetLastChangeDate(@date datetime output)
AS
	select @date = max(AUDIT_DATE_CHANGED) from R2.ReleaseResourceLink
RETURN 0;