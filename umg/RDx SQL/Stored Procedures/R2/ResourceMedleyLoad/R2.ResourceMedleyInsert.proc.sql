﻿-- ============================================
-- Description:	Inserts records in R2.ResourceMedley
-- =============================================
CREATE PROCEDURE [R2].[ResourceMedleyInsert] 
AS
BEGIN
	insert into R2.ResourceMedley
	select 
		l.[RESOURCE_RESOURCE_LINK_ID]
		,l.[RESOURCE_ID]
		,l.[CHILD_RESOURCE_ID]
		,l.[SEQUENCE_NO]
		,l.[PAUSE_TIME]
		,l.[FORMATTED_PAUSE_TIME]
		,l.[ISRC]
		,l.[CHILD_ISRC]
		
		,CHANGE_CODE = ld.CHANGE_CODE 
		,CHANGE_DATE_TIME = ld.CHANGE_DATE_TIME
		,WORKFLOW_CODE = 'L'
	from 
		R2.LoadResourceMedley l
		inner join R2.LoadResourceMedleyDriver ld 
			on l.[RESOURCE_RESOURCE_LINK_ID] = ld.[RESOURCE_RESOURCE_LINK_ID]
	where 
		ld.CHANGE_CODE = 'I' and ld.[WORKFLOW_CODE] = 'T'
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.ResourceMedley', @@rowcount, 'I'
		
END
