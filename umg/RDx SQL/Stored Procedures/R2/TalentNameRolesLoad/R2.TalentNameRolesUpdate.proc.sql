-- ============================================
-- Description:	Updates records in R2.TalentNameRoles
-- =============================================
CREATE PROCEDURE [R2].[TalentNameRolesUpdate] 
AS
BEGIN
	update R2.TalentNameRoles
	set
		TALENT_NAME_ID = ld.TALENT_NAME_ID, 
		ROLES = R2.GetTalentNameRoles(ld.TALENT_NAME_ID),
		CHANGE_CODE = ld.CHANGE_CODE, 
		CHANGE_DATE_TIME = ld.CHANGE_DATE_TIME
		,WORKFLOW_CODE = 'L'
		
	from 
		R2.TalentNameRoles c
		inner join R2.LoadTalentNameRolesDriver ld 
			on c.TALENT_NAME_ID = ld.TALENT_NAME_ID
	where
		ld.CHANGE_CODE = 'U' and ld.[WORKFLOW_CODE] = 'T'
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.TalentNameRoles', @@rowcount, 'U'
		
END
