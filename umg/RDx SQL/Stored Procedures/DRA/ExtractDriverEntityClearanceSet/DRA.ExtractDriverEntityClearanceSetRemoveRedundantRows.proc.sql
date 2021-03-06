﻿-- ============================================
-- Description:	Clears duplicate rows from DRA.ExtractDriverEntityClearanceSet. 
-- =============================================
CREATE PROCEDURE DRA.ExtractDriverEntityClearanceSetRemoveRedundantRows
AS
BEGIN
	-- Clean records with the same ENTITY_CLEARANCE_SET_ID and different change datetime.
	delete DRA.ExtractDriverEntityClearanceSet
	from 
		DRA.ExtractDriverEntityClearanceSet r
		inner join
		(
			-- finds duplicate ENTITY_CLEARANCE_SET_ID
			select ENTITY_CLEARANCE_SET_ID, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME) 
			from DRA.ExtractDriverEntityClearanceSet 
			where [WORKFLOW_CODE] = 'E'
			group by ENTITY_CLEARANCE_SET_ID having count(*) > 1
		) as t
		on 
			r.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID 
		where
			CHANGE_DATE_TIME <> t.MAX_CHANGE_DATE_TIME
			
	-- Clean records with duplicate ENTITY_CLEARANCE_SET_ID
	delete DRA.ExtractDriverEntityClearanceSet
	from 
		DRA.ExtractDriverEntityClearanceSet r
		inner join
		(
			-- finds duplicate ENTITY_CLEARANCE_SET_ID
			select ENTITY_CLEARANCE_SET_ID, MAX_ID = max(ID) 
			from DRA.ExtractDriverEntityClearanceSet 
			where [WORKFLOW_CODE] = 'E'
			group by ENTITY_CLEARANCE_SET_ID having count(*) > 1
		) as t
		on 
			r.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID 
		where
			ID <> t.MAX_ID			
			
END
GO