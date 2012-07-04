CREATE PROCEDURE R2.TalentNameGetLastChangeDate(@date datetime output)
AS
	select @date = max(AUDIT_DATE_CHANGED) from R2.TalentName
RETURN 0;