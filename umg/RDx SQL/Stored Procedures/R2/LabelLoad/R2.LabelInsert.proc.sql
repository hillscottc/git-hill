﻿-- ============================================
-- Description:	Inserts records in R2.Label
-- =============================================
CREATE PROCEDURE R2.LabelInsert 
AS
BEGIN
	insert into R2.Label
	select 
		l.*, 
		CHANGE_CODE = N'I', 
		CHANGE_DATE_TIME = getdate(),
		WORKFLOW_CODE = 'L'
	from 
		R2.Label t
		right outer join R2.LoadLabel l 
			on t.UNIQUE_ID = l.UNIQUE_ID
	where
		t.UNIQUE_ID is null
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Label', @@rowcount, 'I'
		
END
GO