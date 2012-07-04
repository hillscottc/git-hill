-- ============================================
-- Description:	Clears duplicate "Load/Transform (LT)" rows from R2.LoadReleaseLocal. 
-- =============================================
CREATE PROCEDURE [R2].[ReleaseLoadJobRemoveRedundantRowsLocal] 
AS
BEGIN

	-- This cleans multiple change requests for the same "company_id, release_id" pair, but keeps only the last change request
	delete R2.LoadReleaseLocal
	from 
		R2.LoadReleaseLocal r
		inner join
		(
			-- finds duplicate company_id, release_id within the load/transform records (LT)
			select COMPANY_ID, RELEASE_ID, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME) 
			from R2.LoadReleaseLocal 
			where [WORKFLOW_CODE] = 'LT'
			group by COMPANY_ID, RELEASE_ID having count(*) > 1
		) as t
		on 
			r.COMPANY_ID = t.COMPANY_ID and r.RELEASE_ID = t.RELEASE_ID 
		where
			CHANGE_DATE_TIME <> t.MAX_CHANGE_DATE_TIME
			
	-- Clean records with duplicate "company_id, release_id, change_date_time"
	delete R2.LoadReleaseLocal
	from 
		R2.LoadReleaseLocal r
		inner join
		(
			-- finds duplicate company_id, release_id within the load/transform records (LT)
			select COMPANY_ID, RELEASE_ID, MAX_ID = max(ID) 
			from R2.LoadReleaseLocal 
			where [WORKFLOW_CODE] = 'LT'
			group by COMPANY_ID, RELEASE_ID having count(*) > 1
		) as t
		on 
			r.COMPANY_ID = t.COMPANY_ID and r.RELEASE_ID = t.RELEASE_ID 
		where
			ID <> t.MAX_ID						
			
			
END
GO