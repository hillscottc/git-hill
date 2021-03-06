﻿-- ============================================
-- Description:	Deletes records form R2.Role
-- =============================================
CREATE PROCEDURE R2.RoleDelete 
AS
BEGIN
	update R2.Role 
	set CHANGE_CODE = 'UD', CHANGE_DATE_TIME = getdate()
	from 
		R2.Role t
		left outer join R2.LoadRole l on t.ROLE_NO = l.ROLE_NO
	where
		l.ROLE_NO is null
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Role', @@rowcount, 'D'
		
END
GO
