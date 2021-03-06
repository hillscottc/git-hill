﻿-- ============================================
-- Description:	Updates records in R2.Contribution
-- =============================================
CREATE PROCEDURE [R2].[ContributionUpdate] 
AS
BEGIN
	update R2.Contribution
	set
		CONTRIBUTION_ID = l.CONTRIBUTION_ID, 
		UNIQUE_ID = l.UNIQUE_ID, 
		REPERTOIRE_TYPE = l.REPERTOIRE_TYPE, 
		ROLE_NO = l.ROLE_NO, 
		TALENT_NAME_ID = l.TALENT_NAME_ID, 
		AUDIT_DATE_CREATED = l.AUDIT_DATE_CREATED, 
		AUDIT_DATE_CHANGED = l.AUDIT_DATE_CHANGED, 
		AUDIT_EMPLOYEE_NO = l.AUDIT_EMPLOYEE_NO, 
		LABEL_COPY_CREDIT = l.LABEL_COPY_CREDIT, 
		SESSION_ID = l.SESSION_ID, 
		NOTES = l.NOTES, 
		MUSICIAN_CONTRACT_CATEGORY = l.MUSICIAN_CONTRACT_CATEGORY, 
		SEQUENCE_NO = l.SEQUENCE_NO, 
		PRIMARY_INDICATOR = l.PRIMARY_INDICATOR, 

		CHANGE_CODE = ld.CHANGE_CODE, 
		CHANGE_DATE_TIME = ld.CHANGE_DATE_TIME
		,WORKFLOW_CODE = 'L'
		
	from 
		R2.Contribution c
		inner join R2.LoadContribution l 
			on c.CONTRIBUTION_ID = l.CONTRIBUTION_ID
		inner join R2.LoadContributionDriver ld 
			on l.CONTRIBUTION_ID = ld.CONTRIBUTION_ID
	where
		ld.CHANGE_CODE = 'U' and ld.[WORKFLOW_CODE] = 'T'
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Contribution', @@rowcount, 'U'
		
END
