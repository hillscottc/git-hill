﻿-- ============================================
-- Description:	Clears duplicate "Load/Transform (LT)" rows from R2.LoadResource. 
-- =============================================
CREATE PROCEDURE [R2].[ResourceLoadJobRemoveRedundantRows] 
AS
BEGIN

	-- Clean records with the same "Resource_id" and different change datetime.
	delete R2.LoadResource
	from 
		R2.LoadResource r
		inner join
		(
			-- finds duplicate company_id, Resource_id within the load/tramsform records (LT)
			select Resource_ID, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME) 
			from R2.LoadResource 
			where [WORKFLOW_CODE] = 'LT'
			group by Resource_ID having count(*) > 1
		) as t
		on 
			r.Resource_ID = t.Resource_ID 
		where
			CHANGE_DATE_TIME <> t.MAX_CHANGE_DATE_TIME
			
	-- Clean records with duplicate "Resource_id"
	delete R2.LoadResource
	from 
		R2.LoadResource r
		inner join
		(
			-- finds duplicate company_id, Resource_id within the load/tramsform records (LT)
			select Resource_ID, MAX_ID = max(id) 
			from R2.LoadResource 
			where [WORKFLOW_CODE] = 'LT'
			group by Resource_ID having count(*) > 1
		) as t
		on 
			r.Resource_ID = t.Resource_ID 
		where
			ID <> t.MAX_ID			
			
END
GO