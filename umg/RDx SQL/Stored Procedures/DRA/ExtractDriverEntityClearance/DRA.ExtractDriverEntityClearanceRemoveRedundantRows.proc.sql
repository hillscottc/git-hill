-- ============================================
-- Description:	Clears duplicate rows from DRA.ExtractDriverEntityClearance. 
-- =============================================
CREATE PROCEDURE DRA.ExtractDriverEntityClearanceRemoveRedundantRows
AS
BEGIN
	-- Clean records with the same ENTITY_CLEARANCE_ID and different change datetime.
	delete DRA.ExtractDriverEntityClearance
	from 
		DRA.ExtractDriverEntityClearance r
		inner join
		(
			-- finds duplicate ENTITY_CLEARANCE_ID
			select ENTITY_CLEARANCE_ID, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME) 
			from DRA.ExtractDriverEntityClearance 
			where [WORKFLOW_CODE] = 'E'
			group by ENTITY_CLEARANCE_ID having count(*) > 1
		) as t
		on 
			r.ENTITY_CLEARANCE_ID = t.ENTITY_CLEARANCE_ID 
		where
			CHANGE_DATE_TIME <> t.MAX_CHANGE_DATE_TIME
			
	-- Clean records with duplicate ENTITY_CLEARANCE_ID
	delete DRA.ExtractDriverEntityClearance
	from 
		DRA.ExtractDriverEntityClearance r
		inner join
		(
			-- finds duplicate ENTITY_CLEARANCE_ID
			select ENTITY_CLEARANCE_ID, MAX_ID = max(ID) 
			from DRA.ExtractDriverEntityClearance 
			where [WORKFLOW_CODE] = 'E'
			group by ENTITY_CLEARANCE_ID having count(*) > 1
		) as t
		on 
			r.ENTITY_CLEARANCE_ID = t.ENTITY_CLEARANCE_ID 
		where
			ID <> t.MAX_ID			
			
END
GO