﻿-- ============================================
-- Description:	Load records from RMS.CONTROL_MASTER into R2.LoadControl
-- =============================================
CREATE PROCEDURE R2.ControlExtractLoadControlInsert
AS
	insert into R2.LoadControl
	select * 
	from openquery 
	(R2, 
	'
		SELECT 
			C.CONTROL_ID, 
			C.TYPE_, 
			C.ID, 
			C.AUDIT_DATE_CHANGED, 
			C.AUDIT_DATE_CREATED, 
			C.AUDIT_EMPLOYEE_NO, 
			C.COMPANY, 
			C.COUNTRY, 
			
			C.INT1, 
			C.INT2, 
			C.INT3, 
			C.INT4, 
			C.INT5, 
			
			C.TEXT1, 
			C.TEXT2, 
			C.TEXT3, 
			C.TEXT4, 
			C.TEXT5, 
		   
			C.DATE1, 
			C.DATE2, 
			C.DATE3, 
			C.DATE4, 
			C.DATE5, 
			
			C.FLOAT1, 
			C.FLOAT2, 
			C.FLOAT3, 
			C.FLOAT4, 
			C.FLOAT5
		FROM 
			RMS.CONTROL_MASTER C
	');


