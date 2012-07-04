-- ============================================
-- Description:	Updates records in R2.Project
-- =============================================
CREATE PROCEDURE [R2].[ProjectUpdate] 
AS
BEGIN
	update R2.Project
	set
		PROJECT_ID = l.PROJECT_ID,
		CODE = l.CODE,
		DESCRIPTION = l.DESCRIPTION,
		COMPANY_ID = l.COMPANY_ID,
		DIVISION_ID = l.DIVISION_ID,
		LABEL_ID = l.LABEL_ID,
		AUDIT_DATE_CREATED = l.AUDIT_DATE_CREATED,
		AUDIT_DATE_CHANGED = l.AUDIT_DATE_CHANGED,
		AUDIT_EMPLOYEE_NO = l.AUDIT_EMPLOYEE_NO,
		STATUS = l.STATUS,
		ROYALTY_ADMIN = l.ROYALTY_ADMIN,
		BUDGET_NUMBER = l.BUDGET_NUMBER,
		CRA_PROJECT_ID = l.CRA_PROJECT_ID,
		ACCOUNT_ID = l.ACCOUNT_ID,

		CHANGE_CODE = ld.CHANGE_CODE, 
		CHANGE_DATE_TIME = ld.CHANGE_DATE_TIME,
		WORKFLOW_CODE = 'L'
		
	from 
		R2.Project c
		inner join R2.LoadProject l 
			on c.PROJECT_ID = l.PROJECT_ID
		inner join R2.LoadProjectDriver ld 
			on l.PROJECT_ID = ld.PROJECT_ID
	where
		ld.CHANGE_CODE = 'U' and ld.[WORKFLOW_CODE] = 'T'
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Project', @@rowcount, 'U'
		
END
