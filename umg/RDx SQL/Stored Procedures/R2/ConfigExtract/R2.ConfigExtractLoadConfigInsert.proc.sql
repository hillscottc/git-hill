﻿-- ============================================
-- Description:	Load records from RMS.CONFIG_MASTER into R2.LoadConfig
-- =============================================
CREATE PROCEDURE R2.ConfigExtractLoadConfigInsert
AS
	insert into R2.LoadConfig
	select * 
	from openquery 
	(R2, 
	'
		SELECT 
			C.CONFIG_ID, 
			C.CONFIG_GROUP, 
			C.NAME, 
			C.AUDIT_DATE_CREATED, 
			C.AUDIT_DATE_CHANGED, 
			C.AUDIT_EMPLOYEE_NO, 
			C.STATUS, 
			C.NUMBER_OF_SIDES, 
			C.PROGRAM_DESC_1, 
			C.DATE_LAST_GT, 
			C.RELEASE_GROUPING, 
			C.ISAC_CONFIG_CODE, 
			C.UNIQUE_ID, 
			C.DIGITAL_EQUIV_CONFIG_ID, 
			C.CONFIG_TYPE
		FROM 
			RMS.CONFIG_MASTER C
	');


