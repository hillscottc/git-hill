﻿-- ============================================
-- Description:	Inserts records in R2.ResourceResourceAssoc
-- =============================================
CREATE PROCEDURE [R2].[ResourceResourceAssocInsert] 
AS
BEGIN
	insert into R2.ResourceResourceAssoc
	select 
		l.*, 
		CHANGE_CODE = ld.CHANGE_CODE, 
		CHANGE_DATE_TIME = ld.CHANGE_DATE_TIME,
		WORKFLOW_CODE = 'L'
	from 
		R2.LoadResourceResourceAssoc l
		inner join R2.LoadResourceResourceAssocDriver ld 
			on l.RESOURCE_RESOURCE_ASSOC_ID = ld.RESOURCE_RESOURCE_ASSOC_ID
	where 
		ld.CHANGE_CODE = 'I' and ld.[WORKFLOW_CODE] = 'T'
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.ResourceResourceAssoc', @@rowcount, 'I'
		
END
