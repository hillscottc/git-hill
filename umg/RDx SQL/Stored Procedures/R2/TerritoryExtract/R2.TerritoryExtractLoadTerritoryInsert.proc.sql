-- ============================================
-- Description:	Load records from RMS.TERRITORY_MASTER into R2.LoadTerritory
-- =============================================
CREATE PROCEDURE R2.TerritoryExtractLoadTerritoryInsert
AS
	insert into R2.LoadTerritory
	select * 
	from openquery 
	(R2, 
	'
		SELECT 
			T.TERRITORY_ID, 
			T.NAME, 
			T.AUDIT_DATE_CREATED, 
			T.AUDIT_DATE_CHANGED, 
			T.AUDIT_EMPLOYEE_NO, 
			T.STATUS, 
			T.SYNONYM_NAME, 
			T.OFFICIAL_NAME, 
			T.FORMER_NAME, 
			T.ALPHA_3_CODE, 
			T.COMMENTS, 
			T.DATE_LAST_GT
		FROM 
			RMS.TERRITORY_MASTER T
	');


