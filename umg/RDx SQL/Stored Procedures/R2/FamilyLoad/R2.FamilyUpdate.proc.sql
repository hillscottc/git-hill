-- ============================================
-- Description:	Updates records in R2.Family
-- =============================================
CREATE PROCEDURE R2.FamilyUpdate 
AS
BEGIN
	update R2.Family
	set
		[FAMILY_ID] = l.[FAMILY_ID],
		[NAME] = l.[NAME],
		[AUDIT_DATE_CREATED] = l.[AUDIT_DATE_CREATED],
		[AUDIT_DATE_CHANGED] = l.[AUDIT_DATE_CHANGED],
		[AUDIT_EMPLOYEE_NO] = l.[AUDIT_EMPLOYEE_NO],
		[STATUS] = l.[STATUS],
		[DATE_LAST_GT] = l.[DATE_LAST_GT],
		[UNIQUE_ID] = l.[UNIQUE_ID],
		
		CHANGE_CODE = N'U', 
		CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		R2.Family t
		inner join R2.LoadFamily l on t.Family_id = l.Family_id
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Family', @@rowcount, 'U'
		
END
GO