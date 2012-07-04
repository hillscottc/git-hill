-- ============================================
-- Description:	Inserts records in R2.TalentName
-- =============================================
CREATE PROCEDURE [R2].[TalentNameInsert] 
AS
BEGIN
	insert into R2.TalentName
	select 
		l.*, 
		CHANGE_CODE = ld.CHANGE_CODE, 
		CHANGE_DATE_TIME = ld.CHANGE_DATE_TIME,
		WORKFLOW_CODE = 'L'
	from 
		R2.LoadTalentName l
		inner join R2.LoadTalentNameDriver ld 
			on l.TALENT_NAME_ID = ld.TALENT_NAME_ID
	where 
		ld.CHANGE_CODE = 'I' and ld.[WORKFLOW_CODE] = 'T'
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.TalentName', @@rowcount, 'I'
		
END
