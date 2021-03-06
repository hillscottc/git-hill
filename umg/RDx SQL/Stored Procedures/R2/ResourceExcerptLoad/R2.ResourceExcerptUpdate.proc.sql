﻿-- ============================================
-- Description:	Updates records in R2.ResourceExcerpt
-- =============================================
CREATE PROCEDURE R2.ResourceExcerptUpdate
AS
BEGIN
	update R2.ResourceExcerpt
	set
		[RESOURCE_RESOURCE_LINK_ID] = l.[RESOURCE_RESOURCE_LINK_ID]
		,[PARENT_RESOURCE_ID] = l.[PARENT_RESOURCE_ID]
		,[PARENT_ISRC] = l.[PARENT_ISRC]
		,[CHILD_RESOURCE_ID] = l.[CHILD_RESOURCE_ID]
		,[CHILD_ISRC] = l.[CHILD_ISRC]
		,[EXCERPT_START_TIME] = l.[EXCERPT_START_TIME]
		,[EXCERPT_START_TIME_DISPLAY] = l.[EXCERPT_START_TIME_DISPLAY]
		,[EXCERPT_DURATION] = l.[EXCERPT_DURATION]
		,[EXCERPT_DURATION_DISPLAY] = l.[EXCERPT_DURATION_DISPLAY]
		,[EXCERPT_END_TIME] = l.[EXCERPT_END_TIME]
		,[EXCERPT_END_TIME_DISPLAY] = l.[EXCERPT_END_TIME_DISPLAY]
		,[LINK_VERSION] = l.[LINK_VERSION]

		,CHANGE_CODE = ld.CHANGE_CODE 
		,CHANGE_DATE_TIME = ld.CHANGE_DATE_TIME
		,WORKFLOW_CODE = 'L'
	from 
		R2.ResourceExcerpt t
		inner join R2.LoadResourceExcerpt l 
			on t.[RESOURCE_RESOURCE_LINK_ID] = l.[RESOURCE_RESOURCE_LINK_ID]
		inner join R2.LoadResourceExcerptDriver ld 
			on l.[RESOURCE_RESOURCE_LINK_ID] = ld.[RESOURCE_RESOURCE_LINK_ID]
	where
		ld.CHANGE_CODE = 'U' and ld.[WORKFLOW_CODE] = 'T'
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.ResourceExcerpt', @@rowcount, 'U'
		
END
