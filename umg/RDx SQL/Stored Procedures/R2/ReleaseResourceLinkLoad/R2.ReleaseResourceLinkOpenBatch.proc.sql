﻿-- ============================================
-- Description:	Opens a batch of @batchSize for processing in R2.LoadReleaseResourceLinkDriver table.
-- =============================================
CREATE PROCEDURE [R2].[ReleaseResourceLinkOpenBatch] 
@batchSize int
AS
BEGIN
	update top(@batchSize) R2.LoadReleaseResourceLinkDriver
		set [WORKFLOW_CODE] = 'T'
	where 
		[WORKFLOW_CODE] = 'L';

	return @@rowcount;		
END
GO