-- ============================================
-- Description:	Inserts records in R2.Config
-- =============================================
CREATE PROCEDURE R2.ConfigInsert 
AS
BEGIN
	insert into R2.Config
	select 
		l.*, 
		CHANGE_CODE = N'I', 
		CHANGE_DATE_TIME = getdate(),
		WORKFLOW_CODE = 'L'
	from 
		R2.Config t
		right outer join R2.LoadConfig l on t.CONFIG_ID = l.CONFIG_ID
	where
		t.CONFIG_ID is null
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Config', @@rowcount, 'I'
		
END
GO