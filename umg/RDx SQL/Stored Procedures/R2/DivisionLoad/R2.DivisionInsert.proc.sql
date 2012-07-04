-- ============================================
-- Description:	Inserts records in R2.Division
-- =============================================
CREATE PROCEDURE R2.DivisionInsert 
AS
BEGIN
	insert into R2.Division
	select 
		l.*, 
		CHANGE_CODE = N'I', 
		CHANGE_DATE_TIME = getdate(),
		WORKFLOW_CODE = 'L'
	from 
		R2.Division t
		right outer join R2.LoadDivision l on t.Division_id = l.Division_id
	where
		t.Division_id is null
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Division', @@rowcount, 'I'
		
END
GO