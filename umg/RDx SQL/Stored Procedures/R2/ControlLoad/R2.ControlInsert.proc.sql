﻿-- ============================================
-- Description:	Inserts records in R2.Control
-- =============================================
CREATE PROCEDURE R2.ControlInsert 
AS
BEGIN
	insert into R2.Control
	select 
		l.*, 
		CHANGE_CODE = N'I', 
		CHANGE_DATE_TIME = getdate(),
		WORKFLOW_CODE = 'L'
	from 
		R2.Control t
		right outer join R2.LoadControl l on t.CONTROL_ID = l.CONTROL_ID
	where
		t.CONTROL_ID is null
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Control', @@rowcount, 'I'
		
END
GO