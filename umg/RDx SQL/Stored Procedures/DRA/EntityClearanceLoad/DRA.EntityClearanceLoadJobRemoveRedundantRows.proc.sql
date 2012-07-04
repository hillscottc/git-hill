-- ============================================
-- Description:	Clears duplicate "Load/Transform (LT)" rows from DRA.LoadEntityClearance. 
-- =============================================
CREATE PROCEDURE DRA.[EntityClearanceLoadJobRemoveRedundantRows] 
AS
BEGIN

	-- Clean records with the same TerritoryISOCode, UPC, ISRC, RightID and different change datetime.
	delete DRA.LoadEntityClearance
	from 
		DRA.LoadEntityClearance r
		inner join
		(
			-- finds duplicate company_id, TerritoryISOCode, UPC, ISRC, RightID within the load/transform records (LT)
			select ENTITY_CLEARANCE_ID, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME) 
			from DRA.LoadEntityClearance 
			where WORKFLOW_CODE = 'LT'
			group by ENTITY_CLEARANCE_ID having count(*) > 1
		) as t
		on r.ENTITY_CLEARANCE_ID = t.ENTITY_CLEARANCE_ID
		where
			CHANGE_DATE_TIME <> t.MAX_CHANGE_DATE_TIME
			
	-- Clean records with duplicate TerritoryISOCode, UPC, ISRC, RightID
	delete DRA.LoadEntityClearance
	from 
		DRA.LoadEntityClearance r
		inner join
		(
			-- finds duplicate TerritoryISOCode, UPC, ISRC, RightID within the load/transform records (LT)
			select ENTITY_CLEARANCE_ID, MaxID = max(ID) 
			from DRA.LoadEntityClearance 
			where WORKFLOW_CODE = 'LT'
			group by ENTITY_CLEARANCE_ID having count(*) > 1
		) as t
		on r.ENTITY_CLEARANCE_ID = t.ENTITY_CLEARANCE_ID
		where
			ID <> t.MaxID			
			
END
GO