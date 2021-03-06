﻿-- ============================================
-- Description:	Inserts records in DRA.EntityClearanceSet
-- =============================================
CREATE PROCEDURE DRA.[EntityClearanceSetLoadInsert] 
AS
BEGIN
	insert into DRA.EntityClearanceSet
	select 
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
		DRA.LoadEntityClearanceSet l 
		inner join DRA.LoadEntityClearanceSetDriver ld 
			on l.[ENTITY_CLEARANCE_SET_ID] = ld.[ENTITY_CLEARANCE_SET_ID]
	where 
		(ld.CHANGE_CODE = 'I' or ld.CHANGE_CODE = 'ID') and ld.[WORKFLOW_CODE] = 'T'
		and
		l.[WORKFLOW_CODE] = 'LT' 
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.EntityClearanceSet', @@rowcount, 'I'
		
END
