-- =============================================
-- Description:	Clears duplicate "Load/Transform (LT)" rows from CPRS.LoadDigitalProduct. 
-- =============================================
CREATE PROCEDURE [CPRS].[DigitalProductLoadJobRemoveRedundantRows] 
AS
BEGIN

	-- Clean records with the same "ProductID" and different change datetime.
	delete CPRS.LoadDigitalProduct
	from 
		CPRS.LoadDigitalProduct r
		inner join
		(
			-- finds duplicate ProductID within the load/transform records (LT)
			select ProductID, MaxChangeDatetime = max(ChangeDatetime) 
			from CPRS.LoadDigitalProduct 
			where WorkflowCode = 'LT'
			group by ProductID having count(*) > 1
		) as t
		on r.ProductID = t.ProductID
		where
			ChangeDatetime <> t.MaxChangeDatetime
			
	-- Clean records with duplicate "ProductID"
	delete CPRS.LoadDigitalProduct
	from 
		CPRS.LoadDigitalProduct r
		inner join
		(
			-- finds duplicate ProductID within the load/transform records (LT)
			select ProductID, MaxID = max(ID) 
			from CPRS.LoadDigitalProduct 
			where WorkflowCode = 'LT'
			group by ProductID having count(*) > 1
		) as t
		on r.ProductID = t.ProductID
		where
			ID <> t.MaxID			
			
END
GO