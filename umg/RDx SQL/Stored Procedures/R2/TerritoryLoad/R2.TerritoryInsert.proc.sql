-- ============================================
-- Description:	Inserts records in R2.Territory
-- =============================================
CREATE PROCEDURE R2.TerritoryInsert 
AS
BEGIN
	insert into R2.Territory
	select 
		l.*, 
		CHANGE_CODE = N'I', 
		CHANGE_DATE_TIME = getdate(),
		WORKFLOW_CODE = 'L'
	from 
		R2.Territory t
		right outer join R2.LoadTerritory l on t.Territory_id = l.Territory_id
	where
		t.Territory_id is null
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Territory', @@rowcount, 'I'
		
END
GO