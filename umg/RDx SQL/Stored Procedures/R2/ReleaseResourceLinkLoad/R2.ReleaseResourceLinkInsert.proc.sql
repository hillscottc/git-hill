﻿-- ============================================
-- Description:	Inserts records in R2.ReleaseResourceLink
-- =============================================
CREATE PROCEDURE [R2].[ReleaseResourceLinkInsert] 
AS
BEGIN
	insert into R2.ReleaseResourceLink
	select 
		l.*, 
		CHANGE_CODE = ld.CHANGE_CODE, 
		CHANGE_DATE_TIME = ld.CHANGE_DATE_TIME,
		WORKFLOW_CODE = 'L'
	from 
		R2.LoadReleaseResourceLink l
		inner join R2.LoadReleaseResourceLinkDriver ld 
			on l.[RELEASE_RESOURCE_LINK_ID] = ld.[RELEASE_RESOURCE_LINK_ID]
	where 
		ld.CHANGE_CODE = 'I' and ld.[WORKFLOW_CODE] = 'T'
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.ReleaseResourceLink', @@rowcount, 'I'
		
END
