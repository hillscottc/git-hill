-- ============================================
-- Description:	Updates records in R2.Talent
-- =============================================
CREATE PROCEDURE R2.TalentUpdate
AS
BEGIN
	update R2.Talent
	set
		[TALENT_ID] = l.[TALENT_ID]
		,[COMPANY_ID] = l.[COMPANY_ID]
		,[TALENT_TYPE] = l.[TALENT_TYPE]
		,[AUDIT_DATE_CREATED] = l.[AUDIT_DATE_CREATED]
		,[AUDIT_DATE_CHANGED] = l.[AUDIT_DATE_CHANGED]
		,[AUDIT_EMPLOYEE_NO] = l.[AUDIT_EMPLOYEE_NO]
		,[DQ_STATUS] = l.[DQ_STATUS]
		,[COUNTRY_ID] = l.[COUNTRY_ID]
		,[DATE_OF_BIRTH_YEAR] = l.[DATE_OF_BIRTH_YEAR]
		,[DATE_OF_DEATH_YEAR] = l.[DATE_OF_DEATH_YEAR]
		,[RIGHTS_TYPE] = l.[RIGHTS_TYPE]
		,[ACCOUNT_ID] = l.[ACCOUNT_ID]

		,CHANGE_CODE = ld.CHANGE_CODE 
		,CHANGE_DATE_TIME = ld.CHANGE_DATE_TIME
		,WORKFLOW_CODE = 'L'
	from
		R2.Talent t 
		inner join R2.LoadTalent l 
			on t.TALENT_ID = l.TALENT_ID
		inner join R2.LoadTalentDriver ld 
			on l.TALENT_ID = ld.TALENT_ID
	where
		ld.CHANGE_CODE = 'U' and ld.[WORKFLOW_CODE] = 'T'
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Talent', @@rowcount, 'U'
		
END
