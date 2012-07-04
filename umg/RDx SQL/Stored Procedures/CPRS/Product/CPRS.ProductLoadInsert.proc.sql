-- =============================================
-- Description:	Inserts records in CPRS.Product
-- =============================================
CREATE PROCEDURE [CPRS].[ProductLoadInsert] 
AS
BEGIN
	insert into CPRS.Product
	select 
		[ProductID] = l.[ProductID]
		,[UPC] = l.[UPC]
		,[GRID] = l.[GRID]
		,[CPRSArtist] = l.[CPRSArtist]
		,[CPRSTitle] = l.[CPRSTitle]
		,[CPRSVersionTitle] = l.[CPRSVersionTitle]
		,[Availability] = l.[Availability]
		,[LastUpdated] = l.[LastUpdated]
		,[HasExplicitLyrics] = l.[HasExplicitLyrics]
		,[CPRSMusicType] = l.[CPRSMusicType]
		,[CPRSManufacturingType] = l.[CPRSManufacturingType]
		,[CPRSMarketingDivision] = l.[CPRSMarketingDivision]
		,[CPRSRepertoireOwnerLabelID] = l.[CPRSRepertoireOwnerLabelID]
		,[CPRSRepertoireOwnerLabel] = l.[CPRSRepertoireOwnerLabel]
		,[CPRSReleasingLabelID] = l.[CPRSReleasingLabelID]
		,[CPRSReleasingLabel] = l.[CPRSReleasingLabel]
		,[ReleasingTerritoryISO] = l.[ReleasingTerritoryISO]
		,[ReleasingTerritoryName] = l.[ReleasingTerritoryName]
		,[RMSProductID] = l.[RMSProductID]
		,[RMSProjectID] = l.[RMSProjectID]
		,[RMSConfigID] = l.[RMSConfigID]

		,ChangeCode = ld.ChangeCode
		,ChangeDatetime = getdate()
		,WorkflowCode = 'L'
	from 
		CPRS.LoadProduct l 
		inner join CPRS.LoadProductDriver ld 
			on l.ProductID = ld.ProductID
	where 
		(ld.ChangeCode = 'I' or ld.ChangeCode = 'ID') and ld.WorkflowCode = 'T'
		and
		l.WorkflowCode = 'LT' 
		
	-- update row counts		
	exec CPRS.TransformLogTaskInsert 'CPRS.Product', @@rowcount, 'I'
		
END
