﻿-- ============================================
-- Description:	Inserts records in CTX.ExtractDriver
-- =============================================
CREATE PROCEDURE [CTX].[ExtractDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have unprocessed records (i.e. rows with workflow_code = 'E')
	select @existingJobRows = count(*) from CTX.ExtractDriver where WORKFLOW_CODE = 'E'
	if (@existingJobRows > 0)
		return @existingJobRows;

	-- allocate records in CTX.Delta	
	update CTX.Delta set WORKFLOW_CODE = 'T' where WORKFLOW_CODE = 'E'

	-- insert distinct ProductID in the driver
	insert into CTX.ExtractDriver
	(
		CONTRACT_ID, 
		CHANGE_CODE,  
		CHANGE_DATE_TIME,
		WORKFLOW_CODE 
	)
	select 
		CONTRACT_ID = CONTAINER_ID, 
		CHANGE_CODE = case when CHANGE_TYPE <> 'D' then 'C' else 'D' end,
		CHANGE_DATE_TIME = DATE_OF_CHANGE, 
		WORKFLOW_CODE = 'E' 
	from 
		CTX.Delta
	where 
		WORKFLOW_CODE = 'T'
		
	-- mark records in CTX.Delta as complete	
	update CTX.Delta set WORKFLOW_CODE = 'C' where WORKFLOW_CODE = 'T'
		
	return @@rowcount
END
GO