﻿-- ============================================
-- Description:	Inserts records in DRA.EntityRightsPeriod
-- =============================================
CREATE PROCEDURE DRA.[EntityRightsPeriodLoadInsert] 
AS
BEGIN
	insert into DRA.EntityRightsPeriod
	select 
		[ENTITY_CLEARANCE_SET_ID] = l.[ENTITY_CLEARANCE_SET_ID]
		,[RIGHTS_PERIOD_ID] = l.[RIGHTS_PERIOD_ID]
		,[EXPIRY_DATE] = l.[EXPIRY_DATE]

		,CHANGE_CODE = ld.CHANGE_CODE 
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		DRA.LoadEntityRightsPeriod l 
		inner join DRA.LoadEntityRightsPeriodDriver ld 
			on l.ENTITY_CLEARANCE_SET_ID = ld.ENTITY_CLEARANCE_SET_ID and l.RIGHTS_PERIOD_ID = ld.RIGHTS_PERIOD_ID
	where 
		(ld.CHANGE_CODE = 'I' or ld.CHANGE_CODE = 'ID') and ld.[WORKFLOW_CODE] = 'T'
		and
		l.[WORKFLOW_CODE] = 'LT' 
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.EntityRightsPeriod', @@rowcount, 'I'
		
END
