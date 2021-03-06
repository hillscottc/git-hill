﻿-- ============================================
-- Description:	Inserts records in R2.TalentNameRoles
-- =============================================
CREATE PROCEDURE [R2].[TalentNameRolesInsert] 
AS
BEGIN
	insert into R2.TalentNameRoles
	select 
		TALENT_NAME_ID = ld.TALENT_NAME_ID,
		ROLES = R2.GetTalentNameRoles(ld.TALENT_NAME_ID),
		CHANGE_CODE = ld.CHANGE_CODE, 
		CHANGE_DATE_TIME = ld.CHANGE_DATE_TIME,
		WORKFLOW_CODE = 'L'
	from 
		R2.LoadTalentNameRolesDriver ld 
	where 
		ld.CHANGE_CODE = 'I' and ld.[WORKFLOW_CODE] = 'T'
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.TalentNameRoles', @@rowcount, 'I'
		
END
