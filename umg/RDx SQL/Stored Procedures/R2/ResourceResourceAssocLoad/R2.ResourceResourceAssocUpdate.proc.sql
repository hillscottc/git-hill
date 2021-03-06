﻿-- ============================================
-- Description:	Updates records in R2.ResourceResourceAssoc
-- =============================================
CREATE PROCEDURE [R2].[ResourceResourceAssocUpdate] 
AS
BEGIN
	update R2.ResourceResourceAssoc
	set
		RESOURCE_RESOURCE_ASSOC_ID = l.RESOURCE_RESOURCE_ASSOC_ID,
		RESOURCE_COMPANY_LINK_ID = l.RESOURCE_COMPANY_LINK_ID, 
		RESOURCE_ID = l.RESOURCE_ID, 
		AUDIT_DATE_CREATED = l.AUDIT_DATE_CREATED,
		AUDIT_DATE_CHANGED = l.AUDIT_DATE_CHANGED,
		AUDIT_EMPLOYEE_NO = l.AUDIT_EMPLOYEE_NO,

		CHANGE_CODE = ld.CHANGE_CODE, 
		CHANGE_DATE_TIME = ld.CHANGE_DATE_TIME,
		WORKFLOW_CODE = 'L'
		
	from 
		R2.ResourceResourceAssoc c
		inner join R2.LoadResourceResourceAssoc l 
			on c.RESOURCE_RESOURCE_ASSOC_ID = l.RESOURCE_RESOURCE_ASSOC_ID
		inner join R2.LoadResourceResourceAssocDriver ld 
			on l.RESOURCE_RESOURCE_ASSOC_ID = ld.RESOURCE_RESOURCE_ASSOC_ID
	where
		ld.CHANGE_CODE = 'U' and ld.[WORKFLOW_CODE] = 'T'
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.ResourceResourceAssoc', @@rowcount, 'U'
		
END
