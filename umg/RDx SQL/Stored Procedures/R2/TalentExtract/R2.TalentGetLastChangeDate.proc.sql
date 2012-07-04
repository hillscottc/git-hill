CREATE PROCEDURE R2.TalentGetLastChangeDate(@date datetime output)
AS
	select @date = max(AUDIT_DATE_CHANGED) from R2.Talent
RETURN 0;