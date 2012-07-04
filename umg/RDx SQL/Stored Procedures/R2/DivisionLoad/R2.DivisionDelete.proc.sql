-- ============================================
-- Description:	Deletes records form R2.Division
-- =============================================
CREATE PROCEDURE R2.DivisionDelete 
AS
BEGIN
	update R2.Division 
	set CHANGE_CODE = 'UD', CHANGE_DATE_TIME = getdate()
	from 
		R2.Division t
		left outer join R2.LoadDivision l on t.Division_id = l.Division_id
	where
		l.Division_id is null
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Division', @@rowcount, 'D'
		
END
GO
