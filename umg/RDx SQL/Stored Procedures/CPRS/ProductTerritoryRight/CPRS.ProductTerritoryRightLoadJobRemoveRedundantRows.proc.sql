-- =============================================
-- Description:	Clears duplicate "Load/Transform (LT)" rows from CPRS.LoadProductTerritoryRight. 
-- =============================================
CREATE PROCEDURE [CPRS].[ProductTerritoryRightLoadJobRemoveRedundantRows] 
AS
BEGIN

	-- Clean records with the same "ProductID" and different change datetime.
	delete CPRS.LoadProductTerritoryRight
	from 
		CPRS.LoadProductTerritoryRight r
		inner join
		(
			-- finds duplicate ProductID within the load/transform records (LT)
			select ProductMedium, ProductID, ISO, MaxChangeDatetime = max(ChangeDatetime) 
			from CPRS.LoadProductTerritoryRight 
			where WorkflowCode = 'LT'
			group by ProductMedium, ProductID, ISO having count(*) > 1
		) as t
		on r.ProductMedium = t.ProductMedium and r.ProductID = t.ProductID and r.ISO = t.ISO
		where
			ChangeDatetime <> t.MaxChangeDatetime
			
	-- Clean records with duplicate "ProductID"
	delete CPRS.LoadProductTerritoryRight
	from 
		CPRS.LoadProductTerritoryRight r
		inner join
		(
			-- finds duplicate ProductID within the load/transform records (LT)
			select ProductMedium, ProductID, ISO, MaxID = max(ID) 
			from CPRS.LoadProductTerritoryRight 
			where WorkflowCode = 'LT'
			group by ProductMedium, ProductID, ISO having count(*) > 1
		) as t
		on r.ProductMedium = t.ProductMedium and r.ProductID = t.ProductID and r.ISO = t.ISO
		where
			ID <> t.MaxID			
			
END
GO