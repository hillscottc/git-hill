-- ============================================
-- Description:	Clears duplicate rows from DRA.LoadEntityRightsPeriod. 
-- =============================================
CREATE PROCEDURE DRA.[EntityRightsPeriodLoadJobRemoveRedundantRows] 
AS
BEGIN

	-- delete records with the same ENTITY_CLEARANCE_SET_ID, RIGHTS_PERIOD_ID and different change datetime.
	delete DRA.LoadEntityRightsPeriod
	from 
		DRA.LoadEntityRightsPeriod r
		inner join
		(
			-- finds duplicate company_id, ENTITY_CLEARANCE_SET_ID, RIGHTS_PERIOD_ID
			select ENTITY_CLEARANCE_SET_ID, RIGHTS_PERIOD_ID, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME) 
			from DRA.LoadEntityRightsPeriod 
			where WORKFLOW_CODE = 'LT'
			group by ENTITY_CLEARANCE_SET_ID, RIGHTS_PERIOD_ID having count(*) > 1
		) as t
		on r.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID and r.RIGHTS_PERIOD_ID = t.RIGHTS_PERIOD_ID
		where
			CHANGE_DATE_TIME <> t.MAX_CHANGE_DATE_TIME
			
	-- delete records with duplicate ENTITY_CLEARANCE_SET_ID, RIGHTS_PERIOD_ID
	delete DRA.LoadEntityRightsPeriod
	from 
		DRA.LoadEntityRightsPeriod r
		inner join
		(
			-- finds duplicate ENTITY_CLEARANCE_SET_ID, RIGHTS_PERIOD_ID
			select ENTITY_CLEARANCE_SET_ID, RIGHTS_PERIOD_ID, MaxID = max(ID) 
			from DRA.LoadEntityRightsPeriod 
			where WORKFLOW_CODE = 'LT'
			group by ENTITY_CLEARANCE_SET_ID, RIGHTS_PERIOD_ID having count(*) > 1
		) as t
		on r.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID and r.RIGHTS_PERIOD_ID = t.RIGHTS_PERIOD_ID
		where
			ID <> t.MaxID			
			
END
GO