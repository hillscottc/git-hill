-- ============================================
-- Description:	Inserts records in DRA.ExtractDriverEntityClearance
-- =============================================
CREATE PROCEDURE [DRA].[ExtractDriverEntityClearanceLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have unprocessed records (i.e. rows with workflow_code = 'E')
	select @existingJobRows = count(*) from DRA.ExtractDriverEntityClearance where WORKFLOW_CODE = 'E'
	if (@existingJobRows > 0)
		return @existingJobRows;

	declare @rowcount int
	set @rowcount = 0

	-- new / updated
	insert into DRA.ExtractDriverEntityClearance
	(
		ENTITY_CLEARANCE_ID, 
		ENTITY_CLEARANCE_SET_ID,
		CHANGE_CODE,  
		CHANGE_DATE_TIME,
		WORKFLOW_CODE 
	)
	select distinct
		ENTITY_CLEARANCE_ID = ec.ENTITY_CLEARANCE_ID,
		ENTITY_CLEARANCE_SET_ID = d.ENTITY_CLEARANCE_SET_ID, 
		CHANGE_CODE = d.AUDIT_ACTION,
		CHANGE_DATE_TIME = d.DATE_OF_CHANGE, 
		WORKFLOW_CODE = 'E' 
	from
		DRA.LoadEntityClearance ec
		inner join DRA.Delta d
			on ec.ENTITY_CLEARANCE_SET_ID = d.ENTITY_CLEARANCE_SET_ID
	where
		d.AUDIT_ACTION <> 'D'			

	set @rowcount = @rowcount + @@rowcount

	-- deleted
	insert into DRA.ExtractDriverEntityClearance
	(
		ENTITY_CLEARANCE_ID, 
		ENTITY_CLEARANCE_SET_ID,
		CHANGE_CODE,  
		CHANGE_DATE_TIME,
		WORKFLOW_CODE 
	)
	select distinct
		ENTITY_CLEARANCE_ID = ec.ENTITY_CLEARANCE_ID,
		ENTITY_CLEARANCE_SET_ID = d.ENTITY_CLEARANCE_SET_ID, 
		CHANGE_CODE = d.AUDIT_ACTION,
		CHANGE_DATE_TIME = d.DATE_OF_CHANGE, 
		WORKFLOW_CODE = 'E' 
	from
		DRA.EntityClearance ec
		inner join DRA.Delta d
			on ec.ENTITY_CLEARANCE_SET_ID = d.ENTITY_CLEARANCE_SET_ID
	where
		d.AUDIT_ACTION = 'D'			

	set @rowcount = @rowcount + @@rowcount
			
	return @rowcount
END
GO