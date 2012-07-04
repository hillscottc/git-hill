-- ============================================
-- Description:	Deletes all records from the R2.LoadContributionDriver table
-- =============================================
CREATE PROCEDURE [R2].[ContributionClearDriver]
AS
begin
	truncate table R2.LoadContributionDriver;
end	
