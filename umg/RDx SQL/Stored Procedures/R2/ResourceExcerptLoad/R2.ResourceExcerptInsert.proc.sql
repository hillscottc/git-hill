-- ============================================
-- Description:	Inserts records in R2.ResourceExcerpt
-- =============================================
CREATE PROCEDURE [R2].[ResourceExcerptInsert] 
AS
BEGIN
	insert into R2.ResourceExcerpt
	select 
		l.[RESOURCE_RESOURCE_LINK_ID]
		,l.[PARENT_RESOURCE_ID]
		,l.[PARENT_ISRC]
		,l.[CHILD_RESOURCE_ID]
		,l.[CHILD_ISRC]
		,l.[EXCERPT_START_TIME]
		,l.[EXCERPT_START_TIME_DISPLAY]
		,l.[EXCERPT_DURATION]
		,l.[EXCERPT_DURATION_DISPLAY]
		,l.[EXCERPT_END_TIME]
		,l.[EXCERPT_END_TIME_DISPLAY]
		,l.[LINK_VERSION]
		
		,CHANGE_CODE = ld.CHANGE_CODE 
		,CHANGE_DATE_TIME = ld.CHANGE_DATE_TIME
		,WORKFLOW_CODE = 'L'
	from 
		R2.LoadResourceExcerpt l
		inner join R2.LoadResourceExcerptDriver ld 
			on l.[RESOURCE_RESOURCE_LINK_ID] = ld.[RESOURCE_RESOURCE_LINK_ID]
	where 
		ld.CHANGE_CODE = 'I' and ld.[WORKFLOW_CODE] = 'T'
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.ResourceExcerpt', @@rowcount, 'I'
		
END
