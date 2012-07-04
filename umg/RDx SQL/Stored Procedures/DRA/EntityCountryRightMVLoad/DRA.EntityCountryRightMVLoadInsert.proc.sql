-- ============================================
-- Description:	Inserts records in DRA.EntityCountryRightMV
-- =============================================
CREATE PROCEDURE DRA.[EntityCountryRightMVLoadInsert] 
AS
BEGIN
	insert into DRA.EntityCountryRightMV
	select 
		[ENTITY_CLEARANCE_SET_ID] = l.[ENTITY_CLEARANCE_SET_ID]
		,[COUNTRY_ID] = l.[COUNTRY_ID]

		,CHANGE_CODE = ld.CHANGE_CODE 
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		DRA.LoadEntityCountryRightMV l 
		inner join DRA.LoadEntityCountryRightMVDriver ld 
			on l.ENTITY_CLEARANCE_SET_ID = ld.ENTITY_CLEARANCE_SET_ID and l.COUNTRY_ID = ld.COUNTRY_ID
	where 
		(ld.CHANGE_CODE = 'I' or ld.CHANGE_CODE = 'ID') and ld.[WORKFLOW_CODE] = 'T'
		and
		l.[WORKFLOW_CODE] = 'LT' 
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.EntityCountryRightMV', @@rowcount, 'I'
		
END
