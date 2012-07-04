-- ============================================
-- Description:	Clears duplicate rows from DRA.LoadEntityTerritoryRight. 
-- =============================================
CREATE PROCEDURE DRA.[EntityTerritoryRightLoadJobRemoveRedundantRows] 
AS
BEGIN

	-- delete records with the same ENTITY_CLEARANCE_SET_ID, TERRITORY_ID and different change datetime.
	delete DRA.LoadEntityTerritoryRight
	from 
		DRA.LoadEntityTerritoryRight r
		inner join
		(
			-- finds duplicate company_id, ENTITY_CLEARANCE_SET_ID, TERRITORY_ID
			select ENTITY_CLEARANCE_SET_ID, TERRITORY_ID, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME) 
			from DRA.LoadEntityTerritoryRight 
			where WORKFLOW_CODE = 'LT'
			group by ENTITY_CLEARANCE_SET_ID, TERRITORY_ID having count(*) > 1
		) as t
		on r.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID and r.TERRITORY_ID = t.TERRITORY_ID
		where
			CHANGE_DATE_TIME <> t.MAX_CHANGE_DATE_TIME
			
	-- delete records with duplicate ENTITY_CLEARANCE_SET_ID, TERRITORY_ID
	delete DRA.LoadEntityTerritoryRight
	from 
		DRA.LoadEntityTerritoryRight r
		inner join
		(
			-- finds duplicate ENTITY_CLEARANCE_SET_ID, TERRITORY_ID
			select ENTITY_CLEARANCE_SET_ID, TERRITORY_ID, MaxID = max(ID) 
			from DRA.LoadEntityTerritoryRight 
			where WORKFLOW_CODE = 'LT'
			group by ENTITY_CLEARANCE_SET_ID, TERRITORY_ID having count(*) > 1
		) as t
		on r.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID and r.TERRITORY_ID = t.TERRITORY_ID
		where
			ID <> t.MaxID			
			
END
GO