-- ============================================
-- Description:	Updates records in R2.TalentName
-- =============================================
CREATE PROCEDURE R2.TalentNameUpdate
AS
BEGIN
	update R2.TalentName
	set
		[TALENT_NAME_ID] = l.[TALENT_NAME_ID]
		,[TALENT_ID] = l.[TALENT_ID]
		,[LAST_NAME] = l.[LAST_NAME]
		,[AUDIT_DATE_CREATED] = l.[AUDIT_DATE_CREATED]
		,[AUDIT_DATE_CHANGED] = l.[AUDIT_DATE_CHANGED]
		,[AUDIT_EMPLOYEE_NO] = l.[AUDIT_EMPLOYEE_NO]
		,[DQ_STATUS] = l.[DQ_STATUS]
		,[TITLE] = l.[TITLE]
		,[FIRST_NAME] = l.[FIRST_NAME]
		,[LAST_NAME_PREFIX] = l.[LAST_NAME_PREFIX]
		,[ABBREVIATED_NAME] = l.[ABBREVIATED_NAME]
		,[SEARCH_INFORMATION] = l.[SEARCH_INFORMATION]
		,[PARENT_TALENT_NAME_ID] = l.[PARENT_TALENT_NAME_ID]
		,[COUNTRY_ID] = l.[COUNTRY_ID]
		,[DISPLAY_NAME] = l.[DISPLAY_NAME]
		,[FORMATTED_NAME] = l.[FORMATTED_NAME]

		,CHANGE_CODE = ld.CHANGE_CODE 
		,CHANGE_DATE_TIME = ld.CHANGE_DATE_TIME
		,WORKFLOW_CODE = 'L'
	from 
		R2.TalentName t
		inner join R2.LoadTalentName l 
			on t.TALENT_NAME_ID = l.TALENT_NAME_ID
		inner join R2.LoadTalentNameDriver ld 
			on l.TALENT_NAME_ID = ld.TALENT_NAME_ID
	where
		ld.CHANGE_CODE = 'U' and ld.[WORKFLOW_CODE] = 'T'
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.TalentName', @@rowcount, 'U'
		
END
