﻿CREATE PROCEDURE [CPRS].[DigitalProductLoadInsert] 
AS
BEGIN
	insert into CPRS.DigitalProduct
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
		CPRS.LoadDigitalProduct l 
		inner join CPRS.LoadDigitalProductDriver ld 
			on l.ProductID = ld.ProductID
	where 
		(ld.ChangeCode = 'I' or ld.ChangeCode = 'ID') and ld.WorkflowCode = 'T'
		and
		l.WorkflowCode = 'LT' 
		
	-- update row counts		
	exec CPRS.TransformLogTaskInsert 'CPRS.DigitalProduct', @@rowcount, 'I'
		
END
