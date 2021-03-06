﻿-- =============================================
-- Description:	Inserts records in CPRS.ProductTerritoryRight
-- =============================================
CREATE PROCEDURE [CPRS].[ProductTerritoryRightLoadInsert] 
AS
BEGIN
	insert into CPRS.ProductTerritoryRight
	select 
		[ProductID] = l.[ProductID]
		,[UPC] = l.[UPC]
		,[GRID] = l.[GRID]
		,[ProductMedium] = l.[ProductMedium]
		,[ISO] = l.[ISO]

		,ChangeCode = ld.ChangeCode
		,ChangeDatetime = getdate()
		,WorkflowCode = 'L'
	from 
		CPRS.LoadProductTerritoryRight l 
		inner join CPRS.LoadProductTerritoryRightDriver ld 
			on l.ProductMedium = ld.ProductMedium and l.ProductID = ld.ProductID and l.ISO = ld.ISO
	where 
		(ld.ChangeCode = 'I' or ld.ChangeCode = 'ID') and ld.WorkflowCode = 'T'
		and
		l.WorkflowCode = 'LT' 
		
	-- update row counts		
	exec CPRS.TransformLogTaskInsert 'CPRS.ProductTerritoryRight', @@rowcount, 'I'
		
END
