-- ============================================
-- Description:	Updates records in DRA.EntityRightsPeriod
-- =============================================
CREATE PROCEDURE DRA.EntityRightsPeriodLoadUpdate
AS
BEGIN
	update DRA.EntityRightsPeriod
	set
		[ENTITY_CLEARANCE_SET_ID] = l.[ENTITY_CLEARANCE_SET_ID]
		,[RIGHTS_PERIOD_ID] = l.[RIGHTS_PERIOD_ID]
		,[EXPIRY_DATE] = l.[EXPIRY_DATE]
		
		,CHANGE_CODE = ld.CHANGE_CODE
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		DRA.EntityRightsPeriod t
		inner join DRA.LoadEntityRightsPeriod l 
			on t.ENTITY_CLEARANCE_SET_ID = l.ENTITY_CLEARANCE_SET_ID and t.RIGHTS_PERIOD_ID = l.RIGHTS_PERIOD_ID
		inner join DRA.LoadEntityRightsPeriodDriver ld 
			on l.ENTITY_CLEARANCE_SET_ID = ld.ENTITY_CLEARANCE_SET_ID and l.RIGHTS_PERIOD_ID = ld.RIGHTS_PERIOD_ID
	where
		(ld.CHANGE_CODE = 'U' or ld.CHANGE_CODE = 'UD') and ld.WORKFLOW_CODE = 'T'
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.EntityRightsPeriod', @@rowcount, 'U'
		
END
