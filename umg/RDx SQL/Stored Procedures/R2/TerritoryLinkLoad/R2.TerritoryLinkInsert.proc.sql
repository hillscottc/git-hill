﻿-- ============================================
-- Description:	Inserts records in R2.TerritoryLink
-- =============================================
CREATE PROCEDURE R2.TerritoryLinkInsert 
AS
BEGIN
	insert into R2.TerritoryLink
	select 
		l.*, 
		CHANGE_CODE = N'I', 
		CHANGE_DATE_TIME = getdate(),
		WORKFLOW_CODE = 'L'
	from 
		R2.TerritoryLink t
		right outer join R2.LoadTerritoryLink l 
			on t.[TERRITORY_ID] = l.[TERRITORY_ID] and t.[COUNTRY_ID] = l.[COUNTRY_ID]
	where
		(t.[TERRITORY_ID] is null) and (t.[COUNTRY_ID] is null)
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.TerritoryLink', @@rowcount, 'I'
		
END
GO