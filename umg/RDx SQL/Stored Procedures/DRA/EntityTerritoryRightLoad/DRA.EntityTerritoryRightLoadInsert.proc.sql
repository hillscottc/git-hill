-- ============================================
-- Description:	Inserts records in DRA.EntityTerritoryRight
-- =============================================
CREATE PROCEDURE DRA.[EntityTerritoryRightLoadInsert] 
AS
BEGIN
	insert into DRA.EntityTerritoryRight
	select 
		[ENTITY_CLEARANCE_SET_ID] = l.[ENTITY_CLEARANCE_SET_ID]
		,[TERRITORY_ID] = l.[TERRITORY_ID]
		,[MEMBERSHIP_STATE] = l.[MEMBERSHIP_STATE]

		,CHANGE_CODE = ld.CHANGE_CODE 
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		DRA.LoadEntityTerritoryRight l 
		inner join DRA.LoadEntityTerritoryRightDriver ld 
			on l.ENTITY_CLEARANCE_SET_ID = ld.ENTITY_CLEARANCE_SET_ID and l.TERRITORY_ID = ld.TERRITORY_ID
	where 
		(ld.CHANGE_CODE = 'I' or ld.CHANGE_CODE = 'ID') and ld.[WORKFLOW_CODE] = 'T'
		and
		l.[WORKFLOW_CODE] = 'LT' 
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.EntityTerritoryRight', @@rowcount, 'I'
		
END
