-- ============================================
-- Description:	Load records from RMS.Country_MASTER into R2.LoadCountry
-- =============================================
CREATE PROCEDURE R2.CountryExtractLoadCountryInsert
AS
	insert into R2.LoadCountry
	select * 
	from openquery 
	(R2, 
	'
		SELECT 
			C.COUNTRY_ID, 
			C.NAME, 
			C.AUDIT_DATE_CHANGED, 
			C.AUDIT_DATE_CREATED, 
			C.AUDIT_EMPLOYEE_NO, 
			C.STATUS, 
			C.DATE_LAST_GT, 
			C.GT_COUNTRY_ID, 
			C.GT_COUNTRY_CODE, 
			C.UNIQUE_ID
		FROM 
			RMS.COUNTRY_MASTER C
	');


