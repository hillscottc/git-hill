-- ============================================
-- Description:	Load records from RMS.Family_MASTER into R2.LoadFamily
-- =============================================
CREATE PROCEDURE R2.FamilyExtractLoadFamilyInsert
AS
	insert into R2.LoadFamily
	select * 
	from openquery 
	(R2, 
	'
		SELECT 
			F.FAMILY_ID, 
			F.NAME, 
			F.AUDIT_DATE_CREATED, 
			F.AUDIT_DATE_CHANGED, 
			F.AUDIT_EMPLOYEE_NO, 
			F.STATUS, 
			F.DATE_LAST_GT, 
			F.UNIQUE_ID
		FROM 
			RMS.FAMILY_MASTER F    
	');


