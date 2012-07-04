-- ============================================
-- Description:	Deletes records form R2.TerritoryLink
-- =============================================
CREATE PROCEDURE R2.TerritoryLinkDelete 
AS
BEGIN
	update R2.TerritoryLink 
	set CHANGE_CODE = 'UD', CHANGE_DATE_TIME = getdate()
	from 
		R2.TerritoryLink t
		left outer join R2.LoadTerritoryLink l 
			on t.[TERRITORY_ID] = l.[TERRITORY_ID] and t.[COUNTRY_ID] = l.[COUNTRY_ID]
	where
		(l.[TERRITORY_ID] is null) and (l.[COUNTRY_ID] is null)
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.TerritoryLink', @@rowcount, 'U'
		
END
GO
