-- ============================================
-- Description:	Updates records in R2.Role
-- =============================================
CREATE PROCEDURE R2.RoleUpdate 
AS
BEGIN
	update R2.Role
	set
		ROLE_NO = l.ROLE_NO
		,[NAME] = l.[NAME]
		,AUDIT_DATE_CHANGED = l.AUDIT_DATE_CHANGED
		,AUDIT_DATE_CREATED = l.AUDIT_DATE_CREATED
		,AUDIT_EMPLOYEE_NO = l.AUDIT_EMPLOYEE_NO
		,ROLE_GROUP = l.ROLE_GROUP
		,CREDIT_PREFIX = l.CREDIT_PREFIX

		,CHANGE_CODE = N'U' 
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		R2.Role t
		inner join R2.LoadRole l on t.ROLE_NO = l.ROLE_NO
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Role', @@rowcount, 'U'
		
END
GO