﻿-- ============================================
-- Description:	Deletes all records form R2.LoadContribution
-- =============================================
CREATE PROCEDURE R2.ContributionExtractLoadContributionClear 
AS
	truncate table R2.LoadContribution
GO
