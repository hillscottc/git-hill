﻿-- ============================================
-- Description:	Opens a batch of @batchSize for processing in R2.LoadTalentNameRolesDriver table.
-- =============================================
CREATE PROCEDURE [R2].[TalentNameRolesOpenBatch] 
@batchSize int
AS
BEGIN
	update top(@batchSize) R2.LoadTalentNameRolesDriver
		set [WORKFLOW_CODE] = 'T'
	where 
		[WORKFLOW_CODE] = 'L';

	return @@rowcount;		
END
GO