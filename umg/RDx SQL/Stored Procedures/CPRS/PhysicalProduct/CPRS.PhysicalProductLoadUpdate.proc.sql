-- =============================================
-- Description:	Updates records in CPRS.PhysicalProduct
-- =============================================
CREATE PROCEDURE CPRS.PhysicalProductLoadUpdate
AS
BEGIN
	update CPRS.PhysicalProduct
	set
		[ProductID] = l.[ProductID]
		,[UPC] = l.[UPC]
		,[GRID] = l.[GRID]
		,[ReleaseDate] = l.[ReleaseDate]
		,[CPRSVersionTitle] = l.[CPRSVersionTitle]
		,[CPRSProductType] = l.[CPRSProductType]
		,[CPRSStatus] = l.[CPRSStatus]
		,[CPRSFormatCode] = l.[CPRSFormatCode]
		,[CPRSFormat] = l.[CPRSFormat]
		,[SetType] = l.[SetType]
		,[IsCopyProtected] = l.[IsCopyProtected]
		
		,ChangeCode = ld.ChangeCode
		,ChangeDatetime = getdate()
		,WorkflowCode = 'L'
	from 
		CPRS.PhysicalProduct t
		inner join CPRS.LoadPhysicalProduct l 
			on l.ProductID = t.ProductID
		inner join CPRS.LoadPhysicalProductDriver ld 
			on l.ProductID = ld.ProductID
	where
		(ld.ChangeCode = 'U' or ld.ChangeCode = 'UD') and ld.WorkflowCode = 'T'
		and 
		l.WorkflowCode = 'LT'
		
	-- update row counts		
	exec CPRS.TransformLogTaskInsert 'CPRS.PhysicalProduct', @@rowcount, 'U'
		
END
