-- =============================================
-- Description:	Inserts records in CPRS.PhysicalProductLocal
-- =============================================
CREATE PROCEDURE [CPRS].[PhysicalProductLocalLoadInsert] 
AS
BEGIN
	insert into CPRS.PhysicalProductLocal
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
		CPRS.LoadPhysicalProductLocal l 
		inner join CPRS.LoadPhysicalProductLocalDriver ld 
			on l.ProductID = ld.ProductID and l.CountryISO = ld.CountryISO
	where 
		(ld.ChangeCode = 'I' or ld.ChangeCode = 'ID') and ld.WorkflowCode = 'T'
		and
		l.WorkflowCode = 'LT' 
		
	-- update row counts		
	exec CPRS.TransformLogTaskInsert 'CPRS.PhysicalProductLocal', @@rowcount, 'I'
		
END
