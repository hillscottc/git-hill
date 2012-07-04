-- ============================================
-- Description:	Closes a batch in R2.LoadContributionDriver table.
-- =============================================
CREATE PROCEDURE [R2].[ContributionCloseBatch] 
AS
BEGIN
	-- update the driver
	update R2.LoadContributionDriver
		set [WORKFLOW_CODE] = 'C'
	where 
		[WORKFLOW_CODE] = 'T'
END
GO