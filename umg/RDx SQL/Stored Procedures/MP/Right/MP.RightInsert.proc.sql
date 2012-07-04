-- ============================================
-- Description:	Inserts records in R2.Company
-- =============================================
CREATE PROCEDURE MP.RightInsert 
AS
BEGIN
	insert into MP.[Right]
	select 
		l.RightID
		,l.[Name]
		,ChangeCode = 'I'
		,ChangeDatetime = getdate()
		,WorkflowCode = 'L'
	from 
		MP.[Right] t
		right outer join MP.LoadRight l on t.RightID = l.RightID
	where
		t.RightID is null
		
	-- update row counts		
	exec MP.TransformLogTaskInsert 'MP.Right', @@rowcount, 'I'
		
END
GO