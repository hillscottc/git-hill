﻿-- ============================================
-- Description:	Clears duplicate "Load/Transform (LT)" rows from MP.LoadRelease. 
-- =============================================
CREATE PROCEDURE [MP].[ReleaseLoadJobRemoveRedundantRows] 
AS
BEGIN

	-- Clean records with the same "release_id" and different change datetime.
	delete MP.LoadRelease
	from 
		MP.LoadRelease r
		inner join
		(
			-- finds duplicate company_id, release_id within the load/tramsform records (LT)
			select UPC, CompanyID, MaxChangeDatetime = max(ChangeDatetime) 
			from MP.LoadRelease 
			where WorkflowCode = 'LT'
			group by UPC, CompanyID having count(*) > 1
		) as t
		on r.UPC = t.UPC and r.CompanyID = t.CompanyID
		where
			ChangeDatetime <> t.MaxChangeDatetime
			
	-- Clean records with duplicate "release_id"
	delete MP.LoadRelease
	from 
		MP.LoadRelease r
		inner join
		(
			-- finds duplicate release_id within the load/tramsform records (LT)
			select UPC, CompanyID, MaxID = max(ID) 
			from MP.LoadRelease 
			where WorkflowCode = 'LT'
			group by UPC, CompanyID having count(*) > 1
		) as t
		on r.UPC = t.UPC and r.CompanyID = t.CompanyID
		where
			ID <> t.MaxID			
			
END
GO