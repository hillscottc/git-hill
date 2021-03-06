﻿-- =============================================
-- Description:	Updates records in CPRS.PhysicalProductLocal
-- =============================================
CREATE PROCEDURE CPRS.PhysicalProductLocalLoadUpdate
AS
BEGIN
	update CPRS.PhysicalProductLocal
	set
		[ProductID] = l.[ProductID]
		,[UPC] = l.[UPC]
		,[GRID] = l.[GRID]
		,[LLVersionID] = l.[LLVersionID]
		,[CountryISO] = l.[CountryISO]
		,[CountryName] = l.[CountryName]
		,[ReleaseDate] = l.[ReleaseDate]
		,[CPRSReleasingLabelID] = l.[CPRSReleasingLabelID]
		,[CPRSReleasingLabel] = l.[CPRSReleasingLabel]
		
		,ChangeCode = ld.ChangeCode
		,ChangeDatetime = getdate()
		,WorkflowCode = 'L'
	from 
		CPRS.PhysicalProductLocal t
		inner join CPRS.LoadPhysicalProductLocal l 
			on l.ProductID = t.ProductID and l.CountryISO = t.CountryISO
		inner join CPRS.LoadPhysicalProductLocalDriver ld 
			on l.ProductID = ld.ProductID and l.CountryISO = ld.CountryISO
	where
		(ld.ChangeCode = 'U' or ld.ChangeCode = 'UD') and ld.WorkflowCode = 'T'
		and 
		l.WorkflowCode = 'LT'
		
	-- update row counts		
	exec CPRS.TransformLogTaskInsert 'CPRS.PhysicalProductLocal', @@rowcount, 'U'
END
