﻿-- ============================================
-- Description:	Reserves all extracted records (E) in DRA.LoadEntityTerritoryRight for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE DRA.[EntityTerritoryRightLoadJobUpdate] 
AS
BEGIN
	UPDATE DRA.LoadEntityTerritoryRight
	SET WORKFLOW_CODE = 'C' 
	from DRA.LoadEntityTerritoryRight l 
		inner join DRA.LoadEntityTerritoryRightDriver ld 
			on l.ENTITY_CLEARANCE_SET_ID = ld.ENTITY_CLEARANCE_SET_ID and l.TERRITORY_ID = ld.TERRITORY_ID
	where 
		l.WORKFLOW_CODE = 'LT'
		and
		ld.WORKFLOW_CODE = 'T'
END
GO

