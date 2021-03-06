﻿-- ============================================
-- Description:	Updates records in R2.Label
-- =============================================
CREATE PROCEDURE R2.LabelUpdate 
AS
BEGIN
	update R2.Label
	set
		[COMPANY_ID] = l.[COMPANY_ID],
		[DIVISION_ID] = l.[DIVISION_ID],
		[LABEL_ID] = l.[LABEL_ID],
		[NAME] = l.[NAME],
		[AUDIT_DATE_CREATED] = l.[AUDIT_DATE_CREATED],
		[AUDIT_DATE_CHANGED] = l.[AUDIT_DATE_CHANGED],
		[AUDIT_EMPLOYEE_NO] = l.[AUDIT_EMPLOYEE_NO],
		[STATUS] = l.[STATUS],
		[GERMAN_LABEL_CODE] = l.[GERMAN_LABEL_CODE],
		[DATE_LAST_GT] = l.[DATE_LAST_GT],
		[UNIQUE_ID] = l.[UNIQUE_ID],
	
		CHANGE_CODE = N'U', 
		CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		R2.Label t
		inner join R2.LoadLabel l 
			on t.UNIQUE_ID = l.UNIQUE_ID
			
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Label', @@rowcount, 'U'
			
END
GO