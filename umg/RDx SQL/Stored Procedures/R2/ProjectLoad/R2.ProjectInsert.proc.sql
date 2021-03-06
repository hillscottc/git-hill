﻿-- ============================================
-- Description:	Inserts records in R2.Project
-- =============================================
CREATE PROCEDURE [R2].[ProjectInsert] 
AS
BEGIN
	insert into R2.Project
	select 
		l.*, 
		CHANGE_CODE = ld.CHANGE_CODE, 
		CHANGE_DATE_TIME = ld.CHANGE_DATE_TIME,
		WORKFLOW_CODE = 'L'
	from 
		R2.LoadProject l
		inner join R2.LoadProjectDriver ld 
			on l.PROJECT_ID = ld.PROJECT_ID
	where 
		ld.CHANGE_CODE = 'I' and ld.[WORKFLOW_CODE] = 'T'
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Project', @@rowcount, 'I'
		
END
