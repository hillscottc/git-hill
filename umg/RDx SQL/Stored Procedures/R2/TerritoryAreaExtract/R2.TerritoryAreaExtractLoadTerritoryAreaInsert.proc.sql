-- ============================================
-- Description:	Load records from RMS.TERRITORY_AREA_MASTER into R2.LoadTerritoryArea
-- =============================================
CREATE PROCEDURE R2.TerritoryAreaExtractLoadTerritoryAreaInsert
AS
	insert into R2.LoadTerritoryArea
	select * 
	from openquery 
	(R2, 
	'
		SELECT 
			T.TERRITORY_AREA, 
			T.TERRITORY_MEMBER, 
			T.AUDIT_DATE_CREATED, 
			T.AUDIT_DATE_CHANGED, 
			T.AUDIT_EMPLOYEE_NO, 
			T.STATUS, 
			T.DATE_LAST_GT
		FROM 
			RMS.TERRITORY_AREA_MASTER T  
	');


