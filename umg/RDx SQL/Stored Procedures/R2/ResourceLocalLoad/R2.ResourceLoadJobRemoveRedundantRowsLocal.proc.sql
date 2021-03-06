﻿-- ============================================
-- Description:	Clears duplicate "Load/Transform (LT)" rows from R2.LoadResourceLocal. 
-- =============================================
CREATE PROCEDURE [R2].[ResourceLoadJobRemoveRedundantRowsLocal] 
AS
BEGIN

	-- This cleans multiple change requests for the same "company_id, Resource_id" pair, but keeps only the last change request
	delete R2.LoadResourceLocal
	from 
		R2.LoadResourceLocal r
		inner join
		(
			-- finds duplicate company_id, Resource_id within the load/tramsform records (LT)
			select COMPANY_ID, RESOURCE_ID, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME) 
			from R2.LoadResourceLocal 
			where [WORKFLOW_CODE] = 'LT'
			group by COMPANY_ID, RESOURCE_ID having count(*) > 1
		) as t
		on 
			r.COMPANY_ID = t.COMPANY_ID and r.RESOURCE_ID = t.RESOURCE_ID 
		where
			CHANGE_DATE_TIME <> t.MAX_CHANGE_DATE_TIME
			
	-- Clean records with duplicate "company_id, resource_id, change_date_time"
	delete R2.LoadResourceLocal
	from 
		R2.LoadResourceLocal r
		inner join
		(
			-- finds duplicate company_id, release_id, resource_id within the load/transform records (LT)
			select COMPANY_ID, RESOURCE_ID,  MAX_ID = max(ID) 
			from R2.LoadResourceLocal 
			where [WORKFLOW_CODE] = 'LT'
			group by COMPANY_ID, RESOURCE_ID having count(*) > 1
		) as t
		on 
			r.COMPANY_ID = t.COMPANY_ID and r.RESOURCE_ID = t.RESOURCE_ID 
		where
			ID <> t.MAX_ID				
END
GO