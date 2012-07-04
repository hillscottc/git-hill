-- ============================================
-- Description:	Updates records in R2.ReleasePackage
-- =============================================
CREATE PROCEDURE R2.ReleasePackageUpdate
AS
BEGIN
	update R2.ReleasePackage
	set
		[RELEASE_ID] = l.[RELEASE_ID]
		,[COMPONENT_RELEASE_ID] = l.[COMPONENT_RELEASE_ID]
		,[SEQUENCE_NO] = l.[SEQUENCE_NO]
		,[UPC] = l.[UPC]
		,[GRID] = l.[GRID]
		,[COMPONENT_UPC] = l.[COMPONENT_UPC]
		,[COMPONENT_GRID] = l.[COMPONENT_GRID]

		,CHANGE_CODE = ld.CHANGE_CODE 
		,CHANGE_DATE_TIME = ld.CHANGE_DATE_TIME
		,WORKFLOW_CODE = 'L'
	from 
		R2.ReleasePackage t
		inner join R2.LoadReleasePackage l 
			on t.[RELEASE_ID] = l.[RELEASE_ID] and t.[COMPONENT_RELEASE_ID] = l.[COMPONENT_RELEASE_ID]
		inner join R2.LoadReleasePackageDriver ld 
			on l.[RELEASE_ID] = ld.[RELEASE_ID] and l.[COMPONENT_RELEASE_ID] = ld.[COMPONENT_RELEASE_ID]
	where
		ld.CHANGE_CODE = 'U' and ld.[WORKFLOW_CODE] = 'T'
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.ReleasePackage', @@rowcount, 'U'
		
END
