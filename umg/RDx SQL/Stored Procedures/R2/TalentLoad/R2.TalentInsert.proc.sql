﻿-- ============================================
-- Description:	Inserts records in R2.Talent
-- =============================================
CREATE PROCEDURE [R2].[TalentInsert] 
AS
BEGIN
	insert into R2.Talent
	select 
		l.*, 
		CHANGE_CODE = ld.CHANGE_CODE, 
		CHANGE_DATE_TIME = ld.CHANGE_DATE_TIME,
		WORKFLOW_CODE = 'L'
	from 
		R2.LoadTalent l
		inner join R2.LoadTalentDriver ld 
			on l.Talent_ID = ld.Talent_ID
	where 
		ld.CHANGE_CODE = 'I' and ld.[WORKFLOW_CODE] = 'T'
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Talent', @@rowcount, 'I'
		
END
