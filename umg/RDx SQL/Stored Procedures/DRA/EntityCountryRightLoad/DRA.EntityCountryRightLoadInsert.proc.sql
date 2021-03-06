﻿-- ============================================
-- Description:	Inserts records in DRA.EntityCountryRight
-- =============================================
CREATE PROCEDURE DRA.[EntityCountryRightLoadInsert] 
AS
BEGIN
	insert into DRA.EntityCountryRight
	select 
		[ENTITY_CLEARANCE_SET_ID] = l.[ENTITY_CLEARANCE_SET_ID]
		,[COUNTRY_ID] = l.[COUNTRY_ID]
		,[MEMBERSHIP_STATE] = l.[MEMBERSHIP_STATE]

		,CHANGE_CODE = ld.CHANGE_CODE 
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		DRA.LoadEntityCountryRight l 
		inner join DRA.LoadEntityCountryRightDriver ld 
			on l.ENTITY_CLEARANCE_SET_ID = ld.ENTITY_CLEARANCE_SET_ID and l.COUNTRY_ID = ld.COUNTRY_ID
	where 
		(ld.CHANGE_CODE = 'I' or ld.CHANGE_CODE = 'ID') and ld.[WORKFLOW_CODE] = 'T'
		and
		l.[WORKFLOW_CODE] = 'LT' 
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.EntityCountryRight', @@rowcount, 'I'
		
END
