-- ============================================
-- Description:	Updates records in R2.Territory
-- =============================================
CREATE PROCEDURE R2.TerritoryUpdate 
AS
BEGIN
	update R2.Territory
	set
		[TERRITORY_ID] = l.[TERRITORY_ID],
		[NAME] = l.[NAME],
		[AUDIT_DATE_CREATED] = l.[AUDIT_DATE_CREATED],
		[AUDIT_DATE_CHANGED] = l.[AUDIT_DATE_CHANGED],
		[AUDIT_EMPLOYEE_NO] = l.[AUDIT_EMPLOYEE_NO],
		[STATUS] = l.[STATUS],
		[SYNONYM_NAME] = l.[SYNONYM_NAME],
		[OFFICIAL_NAME] = l.[OFFICIAL_NAME],
		[FORMER_NAME] = l.[FORMER_NAME],
		[ALPHA_3_CODE] = l.[ALPHA_3_CODE],
		[COMMENTS] = l.[COMMENTS],
		[DATE_LAST_GT] = l.[DATE_LAST_GT],

		CHANGE_CODE = N'U', 
		CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		R2.Territory t
		inner join R2.LoadTerritory l on t.Territory_id = l.Territory_id
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Territory', @@rowcount, 'U'
		
END
GO