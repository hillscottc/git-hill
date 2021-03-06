﻿-- ============================================
-- Description:	Updates records in DRA.EntityClearanceSet
-- =============================================
CREATE PROCEDURE DRA.EntityClearanceSetLoadUpdate
AS
BEGIN
	update DRA.EntityClearanceSet
	set
		[ENTITY_CLEARANCE_SET_ID] = l.[ENTITY_CLEARANCE_SET_ID]
		,[RESOURCE_ID] = l.[RESOURCE_ID]
		,[RELEASE_ID] = l.[RELEASE_ID]
		,[TERRITORIAL_RIGHTS_NOTES] = l.[TERRITORIAL_RIGHTS_NOTES]
		,[TERRITORIAL_RIGHTS_NOTES_FLAG] = l.[TERRITORIAL_RIGHTS_NOTES_FLAG]
		,[COMPANY_ID] = l.[COMPANY_ID]
		
		,CHANGE_CODE = ld.CHANGE_CODE
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		DRA.EntityClearanceSet t
		inner join DRA.LoadEntityClearanceSet l 
			on t.[ENTITY_CLEARANCE_SET_ID] = l.[ENTITY_CLEARANCE_SET_ID] 
		inner join DRA.LoadEntityClearanceSetDriver ld 
			on l.[ENTITY_CLEARANCE_SET_ID] = ld.[ENTITY_CLEARANCE_SET_ID]
	where
		(ld.CHANGE_CODE = 'U' or ld.CHANGE_CODE = 'UD') and ld.[WORKFLOW_CODE] = 'T'
		and 
		l.[WORKFLOW_CODE] = 'LT'
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.EntityClearanceSet', @@rowcount, 'U'
		
END
