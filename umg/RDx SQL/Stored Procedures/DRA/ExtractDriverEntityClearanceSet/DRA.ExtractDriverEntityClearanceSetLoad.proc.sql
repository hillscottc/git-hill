﻿-- ============================================
-- Description:	Inserts records in DRA.ExtractDriverEntityClearanceSet
-- =============================================
CREATE PROCEDURE [DRA].[ExtractDriverEntityClearanceSetLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have unprocessed records (i.e. rows with workflow_code = 'E')
	select @existingJobRows = count(*) from DRA.ExtractDriverEntityClearanceSet where WORKFLOW_CODE = 'E'
	if (@existingJobRows > 0)
		return @existingJobRows;

	-- allocate records in DRA.Delta	
	update DRA.Delta set WORKFLOW_CODE = 'T' where WORKFLOW_CODE = 'E'

	-- insert distinct ENTITY_CLEARANCE_SET_ID in the driver
	insert into DRA.ExtractDriverEntityClearanceSet
	(
		ENTITY_CLEARANCE_SET_ID, 
		CHANGE_CODE,  
		CHANGE_DATE_TIME,
		WORKFLOW_CODE 
	)
	select 
		ENTITY_CLEARANCE_SET_ID, 
		CHANGE_CODE = AUDIT_ACTION,
		CHANGE_DATE_TIME = DATE_OF_CHANGE, 
		WORKFLOW_CODE = 'E' 
	from 
		DRA.Delta
	where 
		WORKFLOW_CODE = 'T'
		
	-- mark records in DRA.Delta as complete	
	update DRA.Delta set WORKFLOW_CODE = 'C' where WORKFLOW_CODE = 'T'
		
	return @@rowcount
END
GO