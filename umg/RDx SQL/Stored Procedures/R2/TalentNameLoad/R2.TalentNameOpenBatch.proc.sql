﻿-- ============================================
-- Description:	Opens a batch of @batchSize for processing in R2.LoadTalentNameDriver table.
-- =============================================
CREATE PROCEDURE [R2].[TalentNameOpenBatch] 
@batchSize int
AS
BEGIN
	update top(@batchSize) R2.LoadTalentNameDriver
		set [WORKFLOW_CODE] = 'T'
	where 
		[WORKFLOW_CODE] = 'L';

	return @@rowcount;		
END
GO