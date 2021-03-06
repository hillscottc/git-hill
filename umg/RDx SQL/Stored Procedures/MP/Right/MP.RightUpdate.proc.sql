﻿-- ============================================
-- Description:	Updates records in R2.Company
-- =============================================
CREATE PROCEDURE MP.RightUpdate 
AS
BEGIN
	update MP.[Right]
	set
		RightID = l.RightID
		,[Name] = l.[Name]
		,ChangeCode = 'U'
		,ChangeDatetime = getdate()
		,WorkflowCode = 'L'
	from 
		MP.[Right] t
		inner join MP.LoadRight l on t.RightID = l.RightID
		
	-- update row counts		
	exec MP.TransformLogTaskInsert 'MP.Right', @@rowcount, 'U'
		
END
GO