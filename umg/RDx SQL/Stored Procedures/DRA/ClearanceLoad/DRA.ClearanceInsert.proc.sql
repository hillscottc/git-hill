-- ============================================
-- Description:	Inserts records in DRA.Clearance
-- =============================================
CREATE PROCEDURE DRA.ClearanceInsert 
AS
BEGIN
	insert into DRA.Clearance
	select 
		l.*, 
		CHANGE_CODE = N'I', 
		CHANGE_DATE_TIME = getdate(),
		WORKFLOW_CODE = 'L'
	from 
		DRA.Clearance t
		right outer join DRA.LoadClearance l on t.CLEARANCE_ID = l.CLEARANCE_ID
	where
		t.CLEARANCE_ID is null
		
	-- update row counts		
	exec DRA.TransformLogTaskInsert 'DRA.Clearance', @@rowcount, 'I'
		
END
GO