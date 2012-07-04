-- ============================================
-- Description:	Load records from RMS.Division_MASTER into R2.LoadDivision
-- =============================================
CREATE PROCEDURE R2.DivisionExtractLoadDivisionInsert
AS
	insert into R2.LoadDivision
	select * 
	from openquery 
	(R2, 
	'
		SELECT 
			D.COMPANY_ID, 
			D.DIVISION_ID, 
			D.AUDIT_DATE_CREATED, 
			D.AUDIT_DATE_CHANGED, 
			D.AUDIT_EMPLOYEE_NO, 
			D.STATUS, 
			D.NAME, 
			D.DATE_LAST_GT, 
			D.UNIQUE_ID
		FROM 
			RMS.DIVISION_MASTER D	
	');


