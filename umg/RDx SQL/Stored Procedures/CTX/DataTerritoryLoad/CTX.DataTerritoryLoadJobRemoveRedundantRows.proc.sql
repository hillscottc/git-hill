-- ============================================
-- Description:	Clears duplicate rows from CTX.LoadDataTerritory. 
-- =============================================
CREATE PROCEDURE CTX.[DataTerritoryLoadJobRemoveRedundantRows] 
AS
BEGIN

	-- delete records with the same CONTRACT_ID, TERRITORY_TYPE, UNIQUE_ID and different change datetime.
	delete CTX.LoadDataTerritory
	from 
		CTX.LoadDataTerritory r
		inner join
		(
			-- finds duplicate CONTRACT_ID, TERRITORY_TYPE, UNIQUE_ID
			select CONTRACT_ID, TERRITORY_TYPE, UNIQUE_ID, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME) 
			from CTX.LoadDataTerritory 
			where WORKFLOW_CODE = 'LT'
			group by CONTRACT_ID, TERRITORY_TYPE, UNIQUE_ID  having count(*) > 1
		) as t
		on r.CONTRACT_ID = t.CONTRACT_ID 
			and r.TERRITORY_TYPE = t.TERRITORY_TYPE
			and r.UNIQUE_ID = t.UNIQUE_ID
		where
			CHANGE_DATE_TIME <> t.MAX_CHANGE_DATE_TIME
			
	-- delete records with duplicate CONTRACT_ID, TERRITORY_TYPE, UNIQUE_ID 
	delete CTX.LoadDataTerritory
	from 
		CTX.LoadDataTerritory r
		inner join
		(
			-- finds duplicate CONTRACT_ID, TERRITORY_TYPE, UNIQUE_ID
			select CONTRACT_ID, TERRITORY_TYPE, UNIQUE_ID, MaxID = max(ID) 
			from CTX.LoadDataTerritory 
			where WORKFLOW_CODE = 'LT'
			group by CONTRACT_ID, TERRITORY_TYPE, UNIQUE_ID having count(*) > 1
		) as t
		on r.CONTRACT_ID = t.CONTRACT_ID 
			and r.TERRITORY_TYPE = t.TERRITORY_TYPE
			and r.UNIQUE_ID = t.UNIQUE_ID
		where
			ID <> t.MaxID			
			
END
GO