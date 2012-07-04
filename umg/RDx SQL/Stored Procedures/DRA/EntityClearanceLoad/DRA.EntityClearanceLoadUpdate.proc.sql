-- ============================================
-- Description:	Updates records in DRA.EntityClearance
-- =============================================
CREATE PROCEDURE DRA.EntityClearanceLoadUpdate
AS
BEGIN
	-- updated
	update DRA.EntityClearance
	set
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
		DRA.EntityClearance t
		inner join DRA.LoadEntityClearance l 
			on t.ENTITY_CLEARANCE_ID = l.ENTITY_CLEARANCE_ID 
		inner join DRA.LoadEntityClearanceDriver ld 
			on l.ENTITY_CLEARANCE_ID = ld.ENTITY_CLEARANCE_ID
	where
		(ld.CHANGE_CODE = 'U' or ld.CHANGE_CODE = 'UD') and ld.WORKFLOW_CODE = 'T'
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.EntityClearance', @@rowcount, 'U'
		
END
