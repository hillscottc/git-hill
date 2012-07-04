-- ============================================
-- Description:	Load records from RMS.COMPANY_MASTER into R2.LoadCompany
-- =============================================
CREATE PROCEDURE R2.CompanyExtractLoadCompanyInsert
AS
	insert into R2.LoadCompany
	select * 
	from openquery 
	(R2, 
	'
		SELECT 
			C.COUNTRY_ID, 
			C.COMPANY_ID, 
			C.AUDIT_DATE_CREATED, 
			C.AUDIT_DATE_CHANGED, 
			C.AUDIT_EMPLOYEE_NO, 
			C.STATUS, 
			C.LANGUAGE_NO, 
			C.NAME, 
			C.ADDRESS_1, 
			C.ADDRESS_2, 
			C.CITY, 
			C.STATE, 
			C.ZIP_CODE, 
			C.FAMILY_ID, 
			C.DATE_LAST_GT, 
			C.RIGHTS_OWNER_ID, 
			C.UPC_AUTO_ALLOCATION_INDICATOR, 
			C.ISAC_COMPANY_CODE, 
			C.UNIQUE_ID, 
			C.ACCOUNT_ID
		FROM 
			RMS.COMPANY_MASTER C
	');


