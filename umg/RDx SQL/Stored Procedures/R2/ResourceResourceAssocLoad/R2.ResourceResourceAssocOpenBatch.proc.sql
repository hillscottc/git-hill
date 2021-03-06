﻿-- ============================================
-- Description:	Opens a batch of @batchSize for processing in R2.LoadResourceResourceAssocDriver table.
-- =============================================
CREATE PROCEDURE [R2].[ResourceResourceAssocOpenBatch] 
@batchSize int
AS
BEGIN
	update top(@batchSize) R2.LoadResourceResourceAssocDriver
		set [WORKFLOW_CODE] = 'T'
	where 
		[WORKFLOW_CODE] = 'L';

	return @@rowcount;		
END
GO