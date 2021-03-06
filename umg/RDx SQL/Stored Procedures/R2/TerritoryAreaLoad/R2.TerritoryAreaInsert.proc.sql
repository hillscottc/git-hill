﻿-- ============================================
-- Description:	Inserts records in R2.TerritoryArea
-- =============================================
CREATE PROCEDURE R2.TerritoryAreaInsert 
AS
BEGIN
	insert into R2.TerritoryArea
	select 
		l.*, 
		CHANGE_CODE = N'I', 
		CHANGE_DATE_TIME = getdate(),
		WORKFLOW_CODE = 'L'
	from 
		R2.TerritoryArea t
		right outer join R2.LoadTerritoryArea l 
			on t.[TERRITORY_AREA] = l.[TERRITORY_AREA] and t.[TERRITORY_MEMBER] = l.[TERRITORY_MEMBER]
	where
		(t.[TERRITORY_AREA] is null) and (t.[TERRITORY_MEMBER] is null)
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.TerritoryArea', @@rowcount, 'I'
		
END
GO