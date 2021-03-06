﻿-- ============================================
-- Description:	Updates records in R2.Config
-- =============================================
CREATE PROCEDURE R2.ConfigUpdate 
AS
BEGIN
	update R2.Config
	set
		 CONFIG_ID = l.CONFIG_ID, 
		 CONFIG_GROUP = l.CONFIG_GROUP, 
		 NAME = l.NAME, 
		 AUDIT_DATE_CREATED = l.AUDIT_DATE_CREATED, 
		 AUDIT_DATE_CHANGED = l.AUDIT_DATE_CHANGED, 
		 AUDIT_EMPLOYEE_NO = l.AUDIT_EMPLOYEE_NO, 
		 STATUS = l.STATUS, 
		 NUMBER_OF_SIDES = l.NUMBER_OF_SIDES, 
		 PROGRAM_DESC_1 = l.PROGRAM_DESC_1, 
		 DATE_LAST_GT = l.DATE_LAST_GT, 
		 RELEASE_GROUPING = l.RELEASE_GROUPING, 
		 ISAC_CONFIG_CODE = l.ISAC_CONFIG_CODE, 
		 UNIQUE_ID = l.UNIQUE_ID, 
		 DIGITAL_EQUIV_CONFIG_ID = l.DIGITAL_EQUIV_CONFIG_ID, 
		 CONFIG_TYPE = l.CONFIG_TYPE,
			
		CHANGE_CODE = N'U', 
		CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		R2.Config t
		inner join R2.LoadConfig l on t.CONFIG_ID = l.CONFIG_ID
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Config', @@rowcount, 'U'
		
END
GO