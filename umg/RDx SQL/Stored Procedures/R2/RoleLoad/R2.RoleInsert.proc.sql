﻿-- ============================================
-- Description:	Inserts records in R2.Role
-- =============================================
CREATE PROCEDURE R2.RoleInsert 
AS
BEGIN
	insert into R2.Role
	select 
		l.*, 
		CHANGE_CODE = N'I', 
		CHANGE_DATE_TIME = getdate(),
		WORKFLOW_CODE = 'L'
	from 
		R2.Role t
		right outer join R2.LoadRole l on t.ROLE_NO = l.ROLE_NO
	where
		t.ROLE_NO is null
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Role', @@rowcount, 'I'
		
END
GO