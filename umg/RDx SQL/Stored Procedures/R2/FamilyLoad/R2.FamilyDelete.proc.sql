﻿-- ============================================
-- Description:	Deletes records form R2.Family
-- =============================================
CREATE PROCEDURE R2.FamilyDelete 
AS
BEGIN
	update R2.Family 
	set CHANGE_CODE = 'UD', CHANGE_DATE_TIME = getdate()
	from 
		R2.Family t
		left outer join R2.LoadFamily l on t.Family_id = l.Family_id
	where
		l.Family_id is null
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Family', @@rowcount, 'D'
		
END
GO
