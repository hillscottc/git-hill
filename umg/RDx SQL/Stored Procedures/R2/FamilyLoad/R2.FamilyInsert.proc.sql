﻿-- ============================================
-- Description:	Inserts records in R2.Family
-- =============================================
CREATE PROCEDURE R2.FamilyInsert 
AS
BEGIN
	insert into R2.Family
	select 
		l.*, 
		CHANGE_CODE = N'I', 
		CHANGE_DATE_TIME = getdate(),
		WORKFLOW_CODE = 'L'
	from 
		R2.Family t
		right outer join R2.LoadFamily l on t.Family_id = l.Family_id
	where
		t.Family_id is null
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Family', @@rowcount, 'I'
		
END
GO