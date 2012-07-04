-- ============================================
-- Description:	Updates records in R2.ResourceMedley
-- =============================================
CREATE PROCEDURE R2.ResourceMedleyUpdate
AS
BEGIN
	update R2.ResourceMedley
	set
		[RESOURCE_RESOURCE_LINK_ID] = l.[RESOURCE_RESOURCE_LINK_ID]
		,[RESOURCE_ID] = l.[RESOURCE_ID]
		,[CHILD_RESOURCE_ID] = l.[CHILD_RESOURCE_ID]
		,[SEQUENCE_NO] = l.[SEQUENCE_NO]
		,[PAUSE_TIME] = l.[PAUSE_TIME]
		,[FORMATTED_PAUSE_TIME] = l.[FORMATTED_PAUSE_TIME]
		,[ISRC] = l.[ISRC]
		,[CHILD_ISRC] = l.[CHILD_ISRC]

		,CHANGE_CODE = ld.CHANGE_CODE 
		,CHANGE_DATE_TIME = ld.CHANGE_DATE_TIME
		,WORKFLOW_CODE = 'L'
	from 
		R2.ResourceMedley t
		inner join R2.LoadResourceMedley l 
			on t.[RESOURCE_RESOURCE_LINK_ID] = l.[RESOURCE_RESOURCE_LINK_ID]
		inner join R2.LoadResourceMedleyDriver ld 
			on l.[RESOURCE_RESOURCE_LINK_ID] = ld.[RESOURCE_RESOURCE_LINK_ID]
	where
		ld.CHANGE_CODE = 'U' and ld.[WORKFLOW_CODE] = 'T'
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.ResourceMedley', @@rowcount, 'U'
		
END
