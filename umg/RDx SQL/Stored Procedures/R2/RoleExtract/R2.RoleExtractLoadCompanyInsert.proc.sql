﻿-- ============================================
-- Description:	Load records from RMS.ROLE_MASTER into R2.LoadRole
-- =============================================
CREATE PROCEDURE R2.RoleExtractLoadRoleInsert
AS
	insert into R2.LoadRole
	select * 
	from openquery 
	(R2, 
	'
		SELECT 
			R.ROLE_NO, 
			R.NAME, 
			R.AUDIT_DATE_CHANGED, 
			R.AUDIT_DATE_CREATED, 
			R.AUDIT_EMPLOYEE_NO, 
			R.ROLE_GROUP, 
			R.CREDIT_PREFIX
		FROM 
			RMS.ROLE_MASTER R
	');


