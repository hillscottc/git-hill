﻿-- =============================================
-- Description:	Updates records in CPRS.DigitalProduct
-- =============================================
CREATE PROCEDURE CPRS.DigitalProductLoadUpdate
AS
BEGIN
	update CPRS.DigitalProduct
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
		,[ExclusivityStartDate] = l.[ExclusivityStartDate]
		,[ExclusivityEndDate] = l.[ExclusivityEndDate]
		,[NumberOfTracks] = l.[NumberOfTracks]
		,[BizPartner] = l.[BizPartner]
		,[BizPartners] = l.[BizPartners]
		,[ActionsAfter] = l.[ActionsAfter]
		,[AlbumOnly] = l.[AlbumOnly]
		
		,ChangeCode = ld.ChangeCode
		,ChangeDatetime = getdate()
		,WorkflowCode = 'L'
	from 
		CPRS.DigitalProduct t
		inner join CPRS.LoadDigitalProduct l 
			on l.ProductID = t.ProductID
		inner join CPRS.LoadDigitalProductDriver ld 
			on l.ProductID = ld.ProductID
	where
		(ld.ChangeCode = 'U' or ld.ChangeCode = 'UD') and ld.WorkflowCode = 'T'
		and 
		l.WorkflowCode = 'LT'
		
	-- update row counts		
	exec CPRS.TransformLogTaskInsert 'CPRS.DigitalProduct', @@rowcount, 'U'
END
