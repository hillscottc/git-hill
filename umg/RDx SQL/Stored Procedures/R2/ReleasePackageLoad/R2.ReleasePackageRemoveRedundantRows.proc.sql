﻿-- ============================================
-- Description:	Clears duplicate rows from R2.LoadReleasePackage. 
-- =============================================
CREATE PROCEDURE [R2].[ReleasePackageLoadRemoveRedundantRows] 
AS
BEGIN

	-- Clean records with the same RELEASE_ID, COMPONENT_RELEASE_ID and different change datetime.
	delete R2.LoadReleasePackage
	from 
		R2.LoadReleasePackage r
		inner join
		(
			select RELEASE_ID, COMPONENT_RELEASE_ID, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME) 
			from R2.LoadReleasePackage 
			where [WORKFLOW_CODE] = 'E'
			group by RELEASE_ID, COMPONENT_RELEASE_ID having count(*) > 1
		) as t
		on 
			r.RELEASE_ID = t.RELEASE_ID and r.COMPONENT_RELEASE_ID = t.COMPONENT_RELEASE_ID
		where
			CHANGE_DATE_TIME <> t.MAX_CHANGE_DATE_TIME
			
	-- Clean records with duplicate RELEASE_ID, COMPONENT_RELEASE_ID
	delete R2.LoadReleasePackage
	from 
		R2.LoadReleasePackage r
		inner join
		(
			select RELEASE_ID, COMPONENT_RELEASE_ID, MAX_ID = max(ID) 
			from R2.LoadReleasePackage
			where [WORKFLOW_CODE] = 'E'
			group by RELEASE_ID, COMPONENT_RELEASE_ID having count(*) > 1
		) as t
		on 
			r.RELEASE_ID = t.RELEASE_ID and r.COMPONENT_RELEASE_ID = t.COMPONENT_RELEASE_ID 
		where
			ID <> t.MAX_ID			
			
END
GO