﻿-- ============================================
-- Description:	Reserves all extracted records (E) in MP.LoadTrackTerritoryRight for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE [MP].[TrackTerritoryRightLoadJobUpdate] 
AS
BEGIN
	UPDATE MP.LoadTrackTerritoryRight
	SET WorkflowCode = 'C' 
	from MP.LoadTrackTerritoryRight l 
		inner join MP.LoadTrackTerritoryRightDriver ld 
			on l.TerritoryISOCode = ld.TerritoryISOCode and l.UPC = ld.UPC and l.ISRC = ld.ISRC and l.RightID = ld.RightID
	where 
		l.WorkflowCode = 'LT'
		and
		ld.WorkflowCode = 'T'
END
GO