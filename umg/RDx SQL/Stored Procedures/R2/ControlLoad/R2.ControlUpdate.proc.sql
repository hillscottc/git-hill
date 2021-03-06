﻿-- ============================================
-- Description:	Updates records in R2.Control
-- =============================================
CREATE PROCEDURE R2.ControlUpdate 
AS
BEGIN
	update R2.Control
	set
		 CONTROL_ID = l.CONTROL_ID, 
		 TYPE_ = l.TYPE_, 
		 ID = l.ID, 
		 AUDIT_DATE_CHANGED = l.AUDIT_DATE_CHANGED, 
		 AUDIT_DATE_CREATED = l.AUDIT_DATE_CREATED, 
		 AUDIT_EMPLOYEE_NO = l.AUDIT_EMPLOYEE_NO, 
		 COMPANY = l.COMPANY, 
		 COUNTRY = l.COUNTRY, 
		
		 INT1 = l.INT1, 
		 INT2 = l.INT2, 
		 INT3 = l.INT3, 
		 INT4 = l.INT4, 
		 INT5 = l.INT5, 
		
		 TEXT1 = l.TEXT1, 
		 TEXT2 = l.TEXT2, 
		 TEXT3 = l.TEXT3, 
		 TEXT4 = l.TEXT4, 
		 TEXT5 = l.TEXT5, 
	   
		 DATE1 = l.DATE1, 
		 DATE2 = l.DATE2, 
		 DATE3 = l.DATE3, 
		 DATE4 = l.DATE4, 
		 DATE5 = l.DATE5, 
		
		 FLOAT1 = l.FLOAT1, 
		 FLOAT2 = l.FLOAT2, 
		 FLOAT3 = l.FLOAT3, 
		 FLOAT4 = l.FLOAT4, 
		 FLOAT5 = l.FLOAT5,
			
		CHANGE_CODE = N'U', 
		CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		R2.Control t
		inner join R2.LoadControl l on t.CONTROL_ID = l.CONTROL_ID
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Control', @@rowcount, 'U'
		
END
GO