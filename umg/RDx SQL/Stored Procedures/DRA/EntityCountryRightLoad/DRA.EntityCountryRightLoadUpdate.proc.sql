﻿-- ============================================
-- Description:	Updates records in DRA.EntityCountryRight
-- =============================================
CREATE PROCEDURE DRA.EntityCountryRightLoadUpdate
AS
BEGIN
	update DRA.EntityCountryRight
	set
		[ENTITY_CLEARANCE_SET_ID] = l.[ENTITY_CLEARANCE_SET_ID]
		,[COUNTRY_ID] = l.[COUNTRY_ID]
		,[MEMBERSHIP_STATE] = l.[MEMBERSHIP_STATE]
		
		,CHANGE_CODE = ld.CHANGE_CODE
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		DRA.EntityCountryRight t
		inner join DRA.LoadEntityCountryRight l 
			on t.ENTITY_CLEARANCE_SET_ID = l.ENTITY_CLEARANCE_SET_ID and t.COUNTRY_ID = l.COUNTRY_ID
		inner join DRA.LoadEntityCountryRightDriver ld 
			on l.ENTITY_CLEARANCE_SET_ID = ld.ENTITY_CLEARANCE_SET_ID and l.COUNTRY_ID = ld.COUNTRY_ID
	where
		ld.CHANGE_CODE = 'U' and ld.WORKFLOW_CODE = 'T'
		
	update DRA.EntityCountryRight
	set
		CHANGE_CODE = ld.CHANGE_CODE
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		DRA.EntityCountryRight t
		inner join DRA.LoadEntityCountryRightDriver ld 
			on t.ENTITY_CLEARANCE_SET_ID = ld.ENTITY_CLEARANCE_SET_ID and t.COUNTRY_ID = ld.COUNTRY_ID
	where
		ld.CHANGE_CODE = 'UD' and ld.WORKFLOW_CODE = 'T'
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.EntityCountryRight', @@rowcount, 'U'
		
END
