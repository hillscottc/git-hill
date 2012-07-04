-- =============================================
-- Description:	Updates records in CPRS.Product
-- =============================================
CREATE PROCEDURE CPRS.ProductLoadUpdate
AS
BEGIN
	update CPRS.Product
	set
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
		CPRS.Product t
		inner join CPRS.LoadProduct l 
			on l.ProductID = t.ProductID
		inner join CPRS.LoadProductDriver ld 
			on l.ProductID = ld.ProductID
	where
		(ld.ChangeCode = 'U' or ld.ChangeCode = 'UD') and ld.WorkflowCode = 'T'
		and 
		l.WorkflowCode = 'LT'
		
	-- update row counts		
	exec CPRS.TransformLogTaskInsert 'CPRS.Product', @@rowcount, 'U'
		
END
