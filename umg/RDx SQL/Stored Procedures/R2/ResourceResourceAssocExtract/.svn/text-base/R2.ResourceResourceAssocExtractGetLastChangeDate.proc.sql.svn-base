CREATE PROCEDURE R2.ResourceResourceAssocGetLastChangeDate(@date datetime output)
AS
	select @date = max(AUDIT_DATE_CHANGED) from R2.ResourceResourceAssoc
RETURN 0;