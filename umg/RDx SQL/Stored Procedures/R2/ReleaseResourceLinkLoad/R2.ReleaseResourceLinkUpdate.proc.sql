-- ============================================
-- Description:	Updates records in R2.ReleaseResourceLink
-- =============================================
CREATE PROCEDURE R2.ReleaseResourceLinkUpdate
AS
BEGIN
	update R2.ReleaseResourceLink
	set
		[RELEASE_RESOURCE_LINK_ID] = l.[RELEASE_RESOURCE_LINK_ID]
		,[AUDIT_DATE_CREATED] = l.[AUDIT_DATE_CREATED]
		,[AUDIT_DATE_CHANGED] = l.[AUDIT_DATE_CHANGED]
		,[AUDIT_EMPLOYEE_NO] = l.[AUDIT_EMPLOYEE_NO]
		,[RELEASE_ID] = l.[RELEASE_ID]
		,[RESOURCE_ID] = l.[RESOURCE_ID]
		,[PRIMARY_INDICATOR] = l.[PRIMARY_INDICATOR]

		,CHANGE_CODE = ld.CHANGE_CODE 
		,CHANGE_DATE_TIME = ld.CHANGE_DATE_TIME
		,WORKFLOW_CODE = 'L'
	from 
		R2.ReleaseResourceLink t
		inner join R2.LoadReleaseResourceLink l 
			on t.[RELEASE_RESOURCE_LINK_ID] = l.[RELEASE_RESOURCE_LINK_ID]
		inner join R2.LoadReleaseResourceLinkDriver ld 
			on l.[RELEASE_RESOURCE_LINK_ID] = ld.[RELEASE_RESOURCE_LINK_ID]
	where
		ld.CHANGE_CODE = 'U' and ld.[WORKFLOW_CODE] = 'T'
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.ReleaseResourceLink', @@rowcount, 'U'
		
END
