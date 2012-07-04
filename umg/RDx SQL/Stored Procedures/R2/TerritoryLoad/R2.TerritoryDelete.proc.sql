-- ============================================
-- Description:	Deletes records form R2.Territory
-- =============================================
CREATE PROCEDURE R2.TerritoryDelete 
AS
BEGIN
	update R2.Territory 
	set CHANGE_CODE = 'UD', CHANGE_DATE_TIME = getdate()
	from 
		R2.Territory t
		left outer join R2.LoadTerritory l on t.Territory_id = l.Territory_id
	where
		l.Territory_id is null
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Territory', @@rowcount, 'D'
		
END
GO
