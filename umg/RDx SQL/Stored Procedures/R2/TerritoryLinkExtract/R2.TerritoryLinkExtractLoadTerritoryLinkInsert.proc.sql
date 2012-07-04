-- ============================================
-- Description:	Load records from RMS.TERRITORY_LINK_MASTER into R2.LoadTerritoryLink
-- =============================================
CREATE PROCEDURE R2.TerritoryLinkExtractLoadTerritoryLinkInsert
AS
	insert into R2.LoadTerritoryLink
	select * 
	from openquery 
	(R2, 
	'
		SELECT 
			T.TERRITORY_ID, 
			T.COUNTRY_ID, 
			T.AUDIT_DATE_CREATED, 
			T.AUDIT_DATE_CHANGED, 
			T.AUDIT_EMPLOYEE_NO, 
			T.STATUS, 
			T.DATE_LAST_GT
		FROM 
			RMS.TERRITORY_LINK_MASTER T
	');


