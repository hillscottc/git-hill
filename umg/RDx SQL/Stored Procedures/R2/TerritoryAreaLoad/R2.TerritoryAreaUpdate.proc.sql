-- ============================================
-- Description:	Updates records in R2.TerritoryArea
-- =============================================
CREATE PROCEDURE R2.TerritoryAreaUpdate 
AS
BEGIN
	update R2.TerritoryArea
	set
		[TERRITORY_AREA] = l.[TERRITORY_AREA]
		,[TERRITORY_MEMBER] = l.[TERRITORY_MEMBER]
		,[AUDIT_DATE_CREATED] = l.[AUDIT_DATE_CREATED]
		,[AUDIT_DATE_CHANGED] = l.[AUDIT_DATE_CHANGED]
		,[AUDIT_EMPLOYEE_NO] = l.[AUDIT_EMPLOYEE_NO]
		,[STATUS] = l.[STATUS]
		,[DATE_LAST_GT] = l.[DATE_LAST_GT]

		,CHANGE_CODE = N'U' 
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		R2.TerritoryArea t
		inner join R2.LoadTerritoryArea l 
			on t.[TERRITORY_AREA] = l.[TERRITORY_AREA] and t.[TERRITORY_MEMBER] = l.[TERRITORY_MEMBER]
			
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.TerritoryArea', @@rowcount, 'U'
			
END
GO