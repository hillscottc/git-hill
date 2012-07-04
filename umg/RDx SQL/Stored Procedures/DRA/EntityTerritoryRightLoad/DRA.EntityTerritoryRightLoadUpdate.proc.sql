-- ============================================
-- Description:	Updates records in DRA.EntityTerritoryRight
-- =============================================
CREATE PROCEDURE DRA.EntityTerritoryRightLoadUpdate
AS
BEGIN
	update DRA.EntityTerritoryRight
	set
		[ENTITY_CLEARANCE_SET_ID] = l.[ENTITY_CLEARANCE_SET_ID]
		,[TERRITORY_ID] = l.[TERRITORY_ID]
		,[MEMBERSHIP_STATE] = l.[MEMBERSHIP_STATE]
		
		,CHANGE_CODE = ld.CHANGE_CODE
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		DRA.EntityTerritoryRight t
		inner join DRA.LoadEntityTerritoryRight l 
			on t.ENTITY_CLEARANCE_SET_ID = l.ENTITY_CLEARANCE_SET_ID and t.TERRITORY_ID = l.TERRITORY_ID
		inner join DRA.LoadEntityTerritoryRightDriver ld 
			on l.ENTITY_CLEARANCE_SET_ID = ld.ENTITY_CLEARANCE_SET_ID and l.TERRITORY_ID = ld.TERRITORY_ID
	where
		(ld.CHANGE_CODE = 'U' or ld.CHANGE_CODE = 'UD') and ld.WORKFLOW_CODE = 'T'
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.EntityTerritoryRight', @@rowcount, 'U'
END
