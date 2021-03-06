﻿-- =============================================
-- Description:	Updates records in CPRS.ProductTerritoryRight
-- =============================================
CREATE PROCEDURE CPRS.ProductTerritoryRightLoadUpdate
AS
BEGIN
	update CPRS.ProductTerritoryRight
	set
		[ProductID] = l.[ProductID]
		,[UPC] = l.[UPC]
		,[GRID] = l.[GRID]
		,[ProductMedium] = l.[ProductMedium]
		,[ISO] = l.[ISO]
				
		,ChangeCode = ld.ChangeCode
		,ChangeDatetime = getdate()
		,WorkflowCode = 'L'
	from 
		CPRS.ProductTerritoryRight t
		inner join CPRS.LoadProductTerritoryRight l 
			on l.ProductMedium = t.ProductMedium and l.ProductID = t.ProductID and l.ISO = t.ISO
		inner join CPRS.LoadProductTerritoryRightDriver ld 
			on l.ProductMedium = ld.ProductMedium and l.ProductID = ld.ProductID and l.ISO = ld.ISO
	where
		(ld.ChangeCode = 'U' or ld.ChangeCode = 'UD') and ld.WorkflowCode = 'T'
		and 
		l.WorkflowCode = 'LT'
		
	-- update row counts		
	exec CPRS.TransformLogTaskInsert 'CPRS.ProductTerritoryRight', @@rowcount, 'U'
		
END
