﻿-- =============================================
-- Description:	Inserts records in CPRS.DigitalProductLocal
-- =============================================
CREATE PROCEDURE [CPRS].[DigitalProductLocalLoadInsert] 
AS
BEGIN
	insert into CPRS.DigitalProductLocal
	select 
		
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
		CPRS.LoadDigitalProductLocal l 
		inner join CPRS.LoadDigitalProductLocalDriver ld 
			on l.ProductID = ld.ProductID and l.CountryISO = ld.CountryISO
	where 
		(ld.ChangeCode = 'I' or ld.ChangeCode = 'ID') and ld.WorkflowCode = 'T'
		and
		l.WorkflowCode = 'LT' 
		
	-- update row counts		
	exec CPRS.TransformLogTaskInsert 'CPRS.DigitalProductLocal', @@rowcount, 'I'
		
END
