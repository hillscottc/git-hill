-- ============================================
-- Description:	Clears duplicate "Load/Transform (LT)" rows from DRA.LoadEntityClearanceSet. 
-- =============================================
CREATE PROCEDURE DRA.[EntityClearanceSetLoadJobRemoveRedundantRows] 
AS
BEGIN

	-- Clean records with the same ENTITY_CLEARANCE_SET_ID and different change datetime.
	delete DRA.LoadEntityClearanceSet
	from 
		DRA.LoadEntityClearanceSet r
		inner join
		(
			-- finds duplicate ENTITY_CLEARANCE_SET_ID
			select ENTITY_CLEARANCE_SET_ID, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME) 
			from DRA.LoadEntityClearanceSet 
			where [WORKFLOW_CODE] = 'LT'
			group by ENTITY_CLEARANCE_SET_ID having count(*) > 1
		) as t
		on 
			r.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID 
		where
			CHANGE_DATE_TIME <> t.MAX_CHANGE_DATE_TIME
			
	-- Clean records with duplicate ENTITY_CLEARANCE_SET_ID
	delete DRA.LoadEntityClearanceSet
	from 
		DRA.LoadEntityClearanceSet r
		inner join
		(
			-- finds duplicate ENTITY_CLEARANCE_SET_ID
			select ENTITY_CLEARANCE_SET_ID, MAX_ID = max(ID) 
			from DRA.LoadEntityClearanceSet 
			where [WORKFLOW_CODE] = 'LT'
			group by ENTITY_CLEARANCE_SET_ID having count(*) > 1
		) as t
		on 
			r.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID 
		where
			ID <> t.MAX_ID			
			
END
GO