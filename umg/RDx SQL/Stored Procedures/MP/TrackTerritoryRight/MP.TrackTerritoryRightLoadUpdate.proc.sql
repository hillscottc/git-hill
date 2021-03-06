﻿-- ============================================
-- Description:	Updates records in MP.TrackTerritoryRight
-- =============================================
CREATE PROCEDURE MP.TrackTerritoryRightLoadUpdate
AS
BEGIN
	update MP.TrackTerritoryRight
	set
		[UPC] = ld.[UPC]
		,[ISRC] = ld.[ISRC]
		,[RightID] = ld.[RightID]
		,[TerritoryISOCode] = ld.[TerritoryISOCode]

		,ChangeCode = ld.ChangeCode
		,ChangeDatetime = getdate()
		,WorkflowCode = 'L'
	from 
		MP.TrackTerritoryRight t
		inner join MP.LoadTrackTerritoryRightDriver ld 
			on t.TerritoryISOCode = ld.TerritoryISOCode and t.UPC = ld.UPC and t.ISRC = ld.ISRC and t.RightID = ld.RightID
	where
		(ld.ChangeCode = 'U' or ld.ChangeCode = 'UD') and ld.WorkflowCode = 'T'
		
	-- update row counts		
	exec MP.TransformLogTaskInsert 'MP.TrackTerritoryRight', @@rowcount, 'U'
		
END
