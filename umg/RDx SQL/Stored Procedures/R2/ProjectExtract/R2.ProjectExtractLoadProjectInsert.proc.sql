﻿-- ============================================
-- Description:	Load records from RMS.Project_MASTER into R2.LoadProject
-- =============================================
CREATE PROCEDURE R2.ProjectExtractLoadProjectInsert
AS
insert into R2.LoadProject
select * from 
openquery (R2, 
'
	SELECT 
		P.PROJECT_ID, 
		P.CODE, 
		P.DESCRIPTION, 
		P.COMPANY_ID, 
		P.DIVISION_ID, 
		P.LABEL_ID, 
		P.AUDIT_DATE_CREATED, 
		P.AUDIT_DATE_CHANGED, 
		P.AUDIT_EMPLOYEE_NO, 
		P.STATUS, 
		P.ROYALTY_ADMIN, 
		P.BUDGET_NUMBER, 
		P.CRA_PROJECT_ID, 
		P.ACCOUNT_ID
	FROM 
		RMS.PROJECTS P,
		PARTNER.DRIVER_KEY DK
	where
	    P.PROJECT_ID = DK.UNIQUE_ID 
		
		AND DK.REPERTOIRE_TYPE = ''PROJCT''
		AND DK.GENERIC_STRING = ''P''
')
;


