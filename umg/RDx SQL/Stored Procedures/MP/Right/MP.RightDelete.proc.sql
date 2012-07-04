-- ============================================
-- Description:	Deletes records form  MP.Right (only marks them as deleted)
-- =============================================
CREATE PROCEDURE MP.RightDelete 
AS
BEGIN
	
	declare @rows int
	set @rows = 0
	
	-- do not delete records if there is nothing in MP.LoadRight
	select @rows = count(*) from MP.LoadRight
	if (0 = @rows)
		return;

	update MP.[Right]
	set ChangeCode = 'UD', ChangeDatetime = getdate(), Workflowcode = 'L'
	from 
		MP.[Right] t
		left outer join MP.LoadRight l on t.RightID = l.RightID
	where
		l.RightID is null
		
	-- update row counts		
	exec MP.TransformLogTaskInsert 'MP.Right', @@rowcount, 'D'
		
END
GO
