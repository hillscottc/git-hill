-- ============================================
-- Description:	Clears duplicate rows from DRA.LoadEntityCountryRight. 
-- =============================================
CREATE PROCEDURE DRA.[EntityCountryRightLoadJobRemoveRedundantRows] 
AS
BEGIN

	-- delete records with the same ENTITY_CLEARANCE_SET_ID, COUNTRY_ID and different change datetime.
	delete DRA.LoadEntityCountryRight
	from 
		DRA.LoadEntityCountryRight r
		inner join
		(
			-- finds duplicate company_id, ENTITY_CLEARANCE_SET_ID, COUNTRY_ID
			select ENTITY_CLEARANCE_SET_ID, COUNTRY_ID, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME) 
			from DRA.LoadEntityCountryRight 
			where WORKFLOW_CODE = 'LT'
			group by ENTITY_CLEARANCE_SET_ID, COUNTRY_ID having count(*) > 1
		) as t
		on r.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID and r.COUNTRY_ID = t.COUNTRY_ID
		where
			CHANGE_DATE_TIME <> t.MAX_CHANGE_DATE_TIME
			
	-- delete records with duplicate ENTITY_CLEARANCE_SET_ID, COUNTRY_ID
	delete DRA.LoadEntityCountryRight
	from 
		DRA.LoadEntityCountryRight r
		inner join
		(
			-- finds duplicate ENTITY_CLEARANCE_SET_ID, COUNTRY_ID
			select ENTITY_CLEARANCE_SET_ID, COUNTRY_ID, MaxID = max(ID) 
			from DRA.LoadEntityCountryRight 
			where WORKFLOW_CODE = 'LT'
			group by ENTITY_CLEARANCE_SET_ID, COUNTRY_ID having count(*) > 1
		) as t
		on r.ENTITY_CLEARANCE_SET_ID = t.ENTITY_CLEARANCE_SET_ID and r.COUNTRY_ID = t.COUNTRY_ID
		where
			ID <> t.MaxID			
			
END
GO