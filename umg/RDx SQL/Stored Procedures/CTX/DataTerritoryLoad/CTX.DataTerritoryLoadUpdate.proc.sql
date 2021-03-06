﻿-- ============================================
-- Description:	Updates records in CTX.DataTerritory
-- =============================================
CREATE PROCEDURE CTX.DataTerritoryLoadUpdate
AS
BEGIN
	update CTX.DataTerritory
	set
		[CONTRACT_ID] = l.[CONTRACT_ID]
		,[PROPERTY_NM] = l.[PROPERTY_NM]
		,[UNIQUE_ID] = l.[UNIQUE_ID]
		,[TERRITORY_TYPE] = l.[TERRITORY_TYPE]
		,[NAME] = l.[NAME]
		
		,CHANGE_CODE = ld.CHANGE_CODE
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		CTX.DataTerritory t
		inner join CTX.LoadDataTerritory l 
			on t.CONTRACT_ID = l.CONTRACT_ID 
				and t.TERRITORY_TYPE = l.TERRITORY_TYPE
				and t.UNIQUE_ID = l.UNIQUE_ID
		inner join CTX.LoadDataTerritoryDriver ld 
			on l.CONTRACT_ID = ld.CONTRACT_ID 
				and l.TERRITORY_TYPE = ld.TERRITORY_TYPE
				and l.UNIQUE_ID = ld.UNIQUE_ID
	where
		(ld.CHANGE_CODE = 'U' or ld.CHANGE_CODE = 'UD') and ld.WORKFLOW_CODE = 'T'
		
	-- update row counts		
	exec CTX.TransformLogTaskInsert 'CTX.DataTerritory', @@rowcount, 'U'
END
