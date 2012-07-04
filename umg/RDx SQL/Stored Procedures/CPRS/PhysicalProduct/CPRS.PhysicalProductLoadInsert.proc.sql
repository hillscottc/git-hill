-- =============================================
-- Description:	Inserts records in CPRS.PhysicalProduct
-- =============================================
CREATE PROCEDURE [CPRS].[PhysicalProductLoadInsert] 
AS
BEGIN
	insert into CPRS.PhysicalProduct
	select 
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
		CPRS.LoadPhysicalProduct l 
		inner join CPRS.LoadPhysicalProductDriver ld 
			on l.ProductID = ld.ProductID
	where 
		(ld.ChangeCode = 'I' or ld.ChangeCode = 'ID') and ld.WorkflowCode = 'T'
		and
		l.WorkflowCode = 'LT' 
		
	-- update row counts		
	exec CPRS.TransformLogTaskInsert 'CPRS.PhysicalProduct', @@rowcount, 'I'
		
END
