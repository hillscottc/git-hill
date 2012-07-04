-- ============================================
-- Description:	Deletes records form R2.Config
-- =============================================
CREATE PROCEDURE R2.ConfigDelete 
AS
BEGIN
	update R2.Config 
	set CHANGE_CODE = 'UD', CHANGE_DATE_TIME = getdate()
	from 
		R2.Config t
		left outer join R2.LoadConfig l on t.CONFIG_ID = l.CONFIG_ID
	where
		l.CONFIG_ID is null
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Config', @@rowcount, 'D'
		
END
GO
