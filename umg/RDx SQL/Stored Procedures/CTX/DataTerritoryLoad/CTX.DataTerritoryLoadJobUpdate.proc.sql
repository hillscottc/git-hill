-- ============================================
-- Description:	Reserves all extracted records (E) in CTX.LoadDataTerritory for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE CTX.[DataTerritoryLoadJobUpdate] 
AS
BEGIN
	UPDATE CTX.LoadDataTerritory
	SET WORKFLOW_CODE = 'C' 
	from CTX.LoadDataTerritory l 
		inner join CTX.LoadDataTerritoryDriver ld 
			on l.CONTRACT_ID = ld.CONTRACT_ID 
				and l.TERRITORY_TYPE = ld.TERRITORY_TYPE
				and l.UNIQUE_ID = ld.UNIQUE_ID
	where 
		l.WORKFLOW_CODE = 'LT'
		and
		ld.WORKFLOW_CODE = 'T'
END
GO