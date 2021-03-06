﻿-- ============================================
-- Description:	Opens a batch of @batchSize for processing in R2.LoadContributionDriver table.
-- =============================================
CREATE PROCEDURE [R2].[ContributionOpenBatch] 
@batchSize int
AS
BEGIN
	update top(@batchSize) R2.LoadContributionDriver
		set [WORKFLOW_CODE] = 'T'
	where 
		[WORKFLOW_CODE] = 'L';

	return @@rowcount;		
END
GO