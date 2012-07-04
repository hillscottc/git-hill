-- ============================================
-- Description:	Inserts records in DRA.EntityClearance
-- =============================================
CREATE PROCEDURE DRA.[EntityClearanceLoadInsert] 
AS
BEGIN
	insert into DRA.EntityClearance
	select 
		[ENTITY_CLEARANCE_ID] = l.[ENTITY_CLEARANCE_ID]
		,[ENTITY_CLEARANCE_SET_ID] = l.[ENTITY_CLEARANCE_SET_ID]
		,[EXPLOITATION_ID] = l.[EXPLOITATION_ID]
		,[CLEARANCE_ID] = l.[CLEARANCE_ID]
		,[CLEARANCE_STATE] = l.[CLEARANCE_STATE]
		,[DISAGGREGATION_FLAG] = l.[DISAGGREGATION_FLAG]
		,[NOTES] = l.[NOTES]
		,[REJECTION_NOTES] = l.[REJECTION_NOTES]

		,CHANGE_CODE = ld.CHANGE_CODE 
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		DRA.LoadEntityClearance l 
		inner join DRA.LoadEntityClearanceDriver ld 
			on l.ENTITY_CLEARANCE_ID = ld.ENTITY_CLEARANCE_ID
	where 
		(ld.CHANGE_CODE = 'I' or ld.CHANGE_CODE = 'ID') and ld.[WORKFLOW_CODE] = 'T'
		and
		l.[WORKFLOW_CODE] = 'LT' 
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.EntityClearance', @@rowcount, 'I'
		
END
