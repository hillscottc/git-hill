-- ============================================
-- Description:	Updates records in DRA.EntityCountryRightMV
-- =============================================
CREATE PROCEDURE DRA.EntityCountryRightMVLoadUpdate
AS
BEGIN
	update DRA.EntityCountryRightMV
	set
		[ENTITY_CLEARANCE_SET_ID] = l.[ENTITY_CLEARANCE_SET_ID]
		,[COUNTRY_ID] = l.[COUNTRY_ID]
		
		,CHANGE_CODE = ld.CHANGE_CODE
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		DRA.EntityCountryRightMV t
		inner join DRA.LoadEntityCountryRightMV l 
			on t.ENTITY_CLEARANCE_SET_ID = l.ENTITY_CLEARANCE_SET_ID and t.COUNTRY_ID = l.COUNTRY_ID
		inner join DRA.LoadEntityCountryRightMVDriver ld 
			on l.ENTITY_CLEARANCE_SET_ID = ld.ENTITY_CLEARANCE_SET_ID and l.COUNTRY_ID = ld.COUNTRY_ID
	where
		(ld.CHANGE_CODE = 'U' or ld.CHANGE_CODE = 'UD') and ld.WORKFLOW_CODE = 'T'
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.EntityCountryRightMV', @@rowcount, 'U'
		
END
