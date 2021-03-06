﻿-- ============================================
-- Description:	Clears CONTRAXX load tables
-- =============================================
CREATE PROCEDURE [CTX].[ExtractClearLoadDataTables] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have unprocessed records (i.e. rows with workflow_code = 'E')
	select @existingJobRows = count(*) from CTX.ExtractDriver where WORKFLOW_CODE = 'E'
	if (@existingJobRows > 0)
		return;
		
	truncate table [CTX].[LoadDataContract]		
	truncate table [CTX].[LoadDataExploitation]
	truncate table [CTX].[LoadDataRepertoire]
	truncate table [CTX].[LoadDataTerritory]
END
GO