﻿-- ============================================
-- Description:	Load records from RMS.LABEL_MASTER into R2.LoadLabel
-- =============================================
CREATE PROCEDURE R2.LabelExtractLoadLabelInsert
AS
	insert into R2.LoadLabel
	select * 
	from openquery 
	(R2, 
	'
		SELECT 
			L.COMPANY_ID, 
			L.DIVISION_ID, 
			L.LABEL_ID, 
			L.NAME, 
			L.AUDIT_DATE_CREATED, 
			L.AUDIT_DATE_CHANGED, 
			L.AUDIT_EMPLOYEE_NO, 
			L.STATUS, 
			L.GERMAN_LABEL_CODE, 
			L.DATE_LAST_GT, 
			L.UNIQUE_ID
		FROM 
			RMS.LABEL_MASTER L
	');


