﻿-- =============================================
-- Description:	Clears duplicate "Load/Transform (LT)" rows from CPRS.LoadProduct. 
-- =============================================
CREATE PROCEDURE [CPRS].[ProductLoadJobRemoveRedundantRows] 
AS
BEGIN

	-- Clean records with the same "ProductID" and different change datetime.
	delete CPRS.LoadProduct
	from 
		CPRS.LoadProduct r
		inner join
		(
			-- finds duplicate ProductID within the load/transform records (LT)
			select ProductID, MaxChangeDatetime = max(ChangeDatetime) 
			from CPRS.LoadProduct 
			where WorkflowCode = 'LT'
			group by ProductID having count(*) > 1
		) as t
		on r.ProductID = t.ProductID
		where
			ChangeDatetime <> t.MaxChangeDatetime
			
	-- Clean records with duplicate "ProductID"
	delete CPRS.LoadProduct
	from 
		CPRS.LoadProduct r
		inner join
		(
			-- finds duplicate ProductID within the load/transform records (LT)
			select ProductID, MaxID = max(ID) 
			from CPRS.LoadProduct 
			where WorkflowCode = 'LT'
			group by ProductID having count(*) > 1
		) as t
		on r.ProductID = t.ProductID
		where
			ID <> t.MaxID			
			
END
GO