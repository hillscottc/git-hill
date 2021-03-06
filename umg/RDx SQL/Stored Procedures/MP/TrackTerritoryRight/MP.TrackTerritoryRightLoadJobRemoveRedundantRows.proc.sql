﻿-- ============================================
-- Description:	Clears duplicate "Load/Transform (LT)" rows from MP.LoadTrackTerritoryRight. 
-- =============================================
CREATE PROCEDURE [MP].[TrackTerritoryRightLoadJobRemoveRedundantRows] 
AS
BEGIN

	-- Clean records with the same TerritoryISOCode, UPC, ISRC, RightID and different change datetime.
	delete MP.LoadTrackTerritoryRight
	from 
		MP.LoadTrackTerritoryRight r
		inner join
		(
			-- finds duplicate company_id, TerritoryISOCode, UPC, ISRC, RightID within the load/transform records (LT)
			select TerritoryISOCode, UPC, ISRC, RightID, MaxChangeDatetime = max(ChangeDatetime) 
			from MP.LoadTrackTerritoryRight 
			where WorkflowCode = 'LT'
			group by TerritoryISOCode, UPC, ISRC, RightID having count(*) > 1
		) as t
		on r.TerritoryISOCode = t.TerritoryISOCode and r.UPC = t.UPC and r.ISRC = t.ISRC and r.RightID = t.RightID
		where
			ChangeDatetime <> t.MaxChangeDatetime
			
	-- Clean records with duplicate TerritoryISOCode, UPC, ISRC, RightID
	delete MP.LoadTrackTerritoryRight
	from 
		MP.LoadTrackTerritoryRight r
		inner join
		(
			-- finds duplicate TerritoryISOCode, UPC, ISRC, RightID within the load/transform records (LT)
			select TerritoryISOCode, UPC, ISRC, RightID, MaxID = max(ID) 
			from MP.LoadTrackTerritoryRight 
			where WorkflowCode = 'LT'
			group by TerritoryISOCode, UPC, ISRC, RightID having count(*) > 1
		) as t
		on r.TerritoryISOCode = t.TerritoryISOCode and r.UPC = t.UPC and r.ISRC = t.ISRC and r.RightID = t.RightID
		where
			ID <> t.MaxID			
			
END
GO