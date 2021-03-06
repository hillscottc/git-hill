﻿-- ============================================
-- Description:	Clears duplicate rows from DRA.LoadEntityRejectionReason. 
-- =============================================
CREATE PROCEDURE DRA.[EntityRejectionReasonLoadJobRemoveRedundantRows] 
AS
BEGIN

	-- Clean records with the same ENTITY_CLEARANCE_ID, REJECTION_REASON_ID and different change datetime.
	delete DRA.LoadEntityRejectionReason
	from 
		DRA.LoadEntityRejectionReason r
		inner join
		(
			-- finds duplicate company_id, ENTITY_CLEARANCE_ID, REJECTION_REASON_ID
			select ENTITY_CLEARANCE_ID, REJECTION_REASON_ID, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME) 
			from DRA.LoadEntityRejectionReason 
			where WORKFLOW_CODE = 'LT'
			group by ENTITY_CLEARANCE_ID, REJECTION_REASON_ID having count(*) > 1
		) as t
		on r.ENTITY_CLEARANCE_ID = t.ENTITY_CLEARANCE_ID and r.REJECTION_REASON_ID = t.REJECTION_REASON_ID
		where
			CHANGE_DATE_TIME <> t.MAX_CHANGE_DATE_TIME
			
	-- Clean records with duplicate TerritoryISOCode, UPC, ISRC, RightID
	delete DRA.LoadEntityRejectionReason
	from 
		DRA.LoadEntityRejectionReason r
		inner join
		(
			-- finds duplicate ENTITY_CLEARANCE_ID, REJECTION_REASON_ID
			select ENTITY_CLEARANCE_ID, REJECTION_REASON_ID, MaxID = max(ID) 
			from DRA.LoadEntityRejectionReason 
			where WORKFLOW_CODE = 'LT'
			group by ENTITY_CLEARANCE_ID, REJECTION_REASON_ID having count(*) > 1
		) as t
		on r.ENTITY_CLEARANCE_ID = t.ENTITY_CLEARANCE_ID and r.REJECTION_REASON_ID = t.REJECTION_REASON_ID
		where
			ID <> t.MaxID			
			
END
GO