﻿-- ============================================
-- Description:	Inserts records in R2.ReleasePackage
-- =============================================
CREATE PROCEDURE [R2].[ReleasePackageInsert] 
AS
BEGIN
	insert into R2.ReleasePackage
	select 
		l.[RELEASE_ID]
		,l.[COMPONENT_RELEASE_ID]
		,l.[SEQUENCE_NO]
		,l.[UPC]
		,l.[GRID]
		,l.[COMPONENT_UPC]
		,l.[COMPONENT_GRID]
		
		,CHANGE_CODE = ld.CHANGE_CODE 
		,CHANGE_DATE_TIME = ld.CHANGE_DATE_TIME
		,WORKFLOW_CODE = 'L'
	from 
		R2.LoadReleasePackage l
		inner join R2.LoadReleasePackageDriver ld 
			on l.[RELEASE_ID] = ld.[RELEASE_ID] and l.[COMPONENT_RELEASE_ID] = ld.[COMPONENT_RELEASE_ID]

	where 
		ld.CHANGE_CODE = 'I' and ld.[WORKFLOW_CODE] = 'T'
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.ReleasePackage', @@rowcount, 'I'
		
END
