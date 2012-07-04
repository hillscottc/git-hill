-- ============================================
-- Description:	Deletes records form R2.Label
-- =============================================
CREATE PROCEDURE R2.LabelDelete 
AS
BEGIN
	update R2.Label 
	set CHANGE_CODE = 'UD', CHANGE_DATE_TIME = getdate()
	from 
		R2.Label t
		left outer join R2.LoadLabel l 
			on t.UNIQUE_ID = l.UNIQUE_ID
	where
		(l.UNIQUE_ID is null)
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Label', @@rowcount, 'D'
		
END
GO
