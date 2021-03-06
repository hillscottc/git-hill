﻿-- ============================================
-- Description:	Updates records in R2.TerritoryLink
-- =============================================
CREATE PROCEDURE R2.TerritoryLinkUpdate 
AS
BEGIN
	update R2.TerritoryLink
	set
		[TERRITORY_ID] = l.[TERRITORY_ID]
		,[COUNTRY_ID] = l.[COUNTRY_ID]
		,[AUDIT_DATE_CREATED] = l.[AUDIT_DATE_CREATED]
		,[AUDIT_DATE_CHANGED] = l.[AUDIT_DATE_CHANGED]
		,[AUDIT_EMPLOYEE_NO] = l.[AUDIT_EMPLOYEE_NO]
		,[STATUS] = l.[STATUS]
		,[DATE_LAST_GT] = l.[DATE_LAST_GT]

		,CHANGE_CODE = N'U' 
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		R2.TerritoryLink t
		inner join R2.LoadTerritoryLink l 
			on t.[TERRITORY_ID] = l.[TERRITORY_ID] and t.[COUNTRY_ID] = l.[COUNTRY_ID]
			
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.TerritoryLink', @@rowcount, 'U'
			
END
GO