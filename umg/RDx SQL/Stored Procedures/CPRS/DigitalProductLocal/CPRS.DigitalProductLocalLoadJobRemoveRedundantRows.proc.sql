﻿-- =============================================
-- Description:	Clears duplicate "Load/Transform (LT)" rows from CPRS.LoadDigitalProductLocal. 
-- =============================================
CREATE PROCEDURE [CPRS].[DigitalProductLocalLoadJobRemoveRedundantRows] 
AS
BEGIN

	-- Clean records with the same "ProductID" and different change datetime.
	delete CPRS.LoadDigitalProductLocal
	from 
		CPRS.LoadDigitalProductLocal r
		inner join
		(
			-- finds duplicate ProductID within the load/transform records (LT)
			select ProductID, CountryISO, MaxChangeDatetime = max(ChangeDatetime) 
			from CPRS.LoadDigitalProductLocal 
			where WorkflowCode = 'LT'
			group by ProductID, CountryISO having count(*) > 1
		) as t
		on r.ProductID = t.ProductID and r.CountryISO = t.CountryISO
		where
			ChangeDatetime <> t.MaxChangeDatetime
			
	-- Clean records with duplicate "ProductID"
	delete CPRS.LoadDigitalProductLocal
	from 
		CPRS.LoadDigitalProductLocal r
		inner join
		(
			-- finds duplicate ProductID within the load/transform records (LT)
			select ProductID, CountryISO, MaxID = max(ID) 
			from CPRS.LoadDigitalProductLocal 
			where WorkflowCode = 'LT'
			group by ProductID, CountryISO having count(*) > 1
		) as t
		on r.ProductID = t.ProductID and r.CountryISO = t.CountryISO
		where
			ID <> t.MaxID			
			
END
GO