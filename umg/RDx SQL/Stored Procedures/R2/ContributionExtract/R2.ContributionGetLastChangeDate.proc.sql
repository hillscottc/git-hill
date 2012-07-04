CREATE PROCEDURE R2.ContributionGetLastChangeDate(@date datetime output)
AS
	select @date = max(AUDIT_DATE_CHANGED) from R2.Contribution
RETURN 0;