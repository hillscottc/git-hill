﻿-- ============================================
-- Description:	Deletes records form R2.Control
-- =============================================
CREATE PROCEDURE R2.ControlDelete 
AS
BEGIN
	update R2.Control 
	set CHANGE_CODE = 'UD', CHANGE_DATE_TIME = getdate()
	from 
		R2.Control t
		left outer join R2.LoadControl l on t.CONTROL_ID = l.CONTROL_ID
	where
		l.CONTROL_ID is null
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Control', @@rowcount, 'D'
		
END
GO
