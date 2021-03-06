﻿-- ============================================
-- Description:	Deletes records form R2.TerritoryArea
-- =============================================
CREATE PROCEDURE R2.TerritoryAreaDelete 
AS
BEGIN
	update R2.TerritoryArea 
	set CHANGE_CODE = 'UD', CHANGE_DATE_TIME = getdate()
	from 
		R2.TerritoryArea t
		left outer join R2.LoadTerritoryArea l 
			on t.[TERRITORY_AREA] = l.[TERRITORY_AREA] and t.[TERRITORY_MEMBER] = l.[TERRITORY_MEMBER]
	where
		(l.[TERRITORY_AREA] is null) and (l.[TERRITORY_MEMBER] is null)
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.TerritoryArea', @@rowcount, 'D'
		
END
GO
