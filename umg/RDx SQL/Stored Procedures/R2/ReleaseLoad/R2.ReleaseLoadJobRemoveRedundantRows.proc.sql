﻿-- ============================================
-- Description:	Clears duplicate rows from R2.LoadRelease. 
-- =============================================
CREATE PROCEDURE [R2].[ReleaseLoadJobRemoveRedundantRows] 
AS
BEGIN

	-- Clean records with the same "release_id" and different change datetime.
	delete R2.LoadRelease
	from 
		R2.LoadRelease r
		inner join
		(
			-- finds duplicate release_id
			select RELEASE_ID, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME) 
			from R2.LoadRelease 
			where [WORKFLOW_CODE] = 'LT'
			group by RELEASE_ID having count(*) > 1
		) as t
		on 
			r.RELEASE_ID = t.RELEASE_ID 
		where
			CHANGE_DATE_TIME <> t.MAX_CHANGE_DATE_TIME
			
	-- Clean records with duplicate "release_id"
	delete R2.LoadRelease
	from 
		R2.LoadRelease r
		inner join
		(
			-- finds duplicate release_id
			select RELEASE_ID, MAX_ID = max(ID) 
			from R2.LoadRelease 
			where [WORKFLOW_CODE] = 'LT'
			group by RELEASE_ID having count(*) > 1
		) as t
		on 
			r.RELEASE_ID = t.RELEASE_ID 
		where
			ID <> t.MAX_ID			
			
END
GO