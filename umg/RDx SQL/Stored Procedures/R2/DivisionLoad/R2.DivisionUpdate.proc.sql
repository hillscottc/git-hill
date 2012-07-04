-- ============================================
-- Description:	Updates records in R2.Division
-- =============================================
CREATE PROCEDURE R2.DivisionUpdate 
AS
BEGIN
	update R2.Division
	set
		[COMPANY_ID] = l.[COMPANY_ID],
		[DIVISION_ID] = l.[DIVISION_ID],
		[AUDIT_DATE_CREATED] = l.[AUDIT_DATE_CREATED],
		[AUDIT_DATE_CHANGED] = l.[AUDIT_DATE_CHANGED],
		[AUDIT_EMPLOYEE_NO] = l.[AUDIT_EMPLOYEE_NO],
		[STATUS] = l.[STATUS],
		[NAME] = l.[NAME],
		[DATE_LAST_GT] = l.[DATE_LAST_GT],
		[UNIQUE_ID] = l.[UNIQUE_ID],

		CHANGE_CODE = N'U', 
		CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		R2.Division t
		inner join R2.LoadDivision l on t.Division_id = l.Division_id
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Division', @@rowcount, 'U'
		
END
GO