-- ============================================
-- Description:	Updates records in R2.Company
-- =============================================
CREATE PROCEDURE R2.CompanyUpdate 
AS
BEGIN
	update R2.Company
	set
		COUNTRY_ID = l.COUNTRY_ID, 
		COMPANY_ID = l.COMPANY_ID, 
		AUDIT_DATE_CREATED = l.AUDIT_DATE_CREATED, 
		AUDIT_DATE_CHANGED = l.AUDIT_DATE_CHANGED, 
		AUDIT_EMPLOYEE_NO = l.AUDIT_EMPLOYEE_NO, 
		STATUS = l.STATUS, 
		LANGUAGE_NO = l.LANGUAGE_NO, 
		NAME = l.NAME, 
		ADDRESS_1 = l.ADDRESS_1, 
		ADDRESS_2 = l.ADDRESS_2, 
		CITY = l.CITY, 
		STATE = l.STATE, 
		ZIP_CODE = l.ZIP_CODE, 
		FAMILY_ID = l.FAMILY_ID, 
		DATE_LAST_GT = l.DATE_LAST_GT, 
		RIGHTS_OWNER_ID = l.RIGHTS_OWNER_ID, 
		UPC_AUTO_ALLOCATION_INDICATOR = l.UPC_AUTO_ALLOCATION_INDICATOR, 
		ISAC_COMPANY_CODE = l.ISAC_COMPANY_CODE, 
		UNIQUE_ID = l.UNIQUE_ID, 
		ACCOUNT_ID = l.ACCOUNT_ID,

		CHANGE_CODE = N'U', 
		CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		R2.Company t
		inner join R2.LoadCompany l on t.company_id = l.company_id
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.LoadCompany', @@rowcount, 'U'
END
GO