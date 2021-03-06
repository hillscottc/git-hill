﻿-- ============================================
-- Description:	Inserts records in CTX.DataTerritory
-- =============================================
CREATE PROCEDURE CTX.[DataTerritoryLoadInsert] 
AS
BEGIN
	insert into CTX.DataTerritory
	select 
		[CONTRACT_ID] = l.[CONTRACT_ID]
		,[PROPERTY_NM] = l.[PROPERTY_NM]
		,[UNIQUE_ID] = l.[UNIQUE_ID]
		,[TERRITORY_TYPE] = l.[TERRITORY_TYPE]
		,[NAME] = l.[NAME]

		,CHANGE_CODE = ld.CHANGE_CODE 
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		CTX.LoadDataTerritory l 
		inner join CTX.LoadDataTerritoryDriver ld 
			on l.CONTRACT_ID = ld.CONTRACT_ID 
				and l.TERRITORY_TYPE = ld.TERRITORY_TYPE
				and l.UNIQUE_ID = ld.UNIQUE_ID
	where 
		(ld.CHANGE_CODE = 'I' or ld.CHANGE_CODE = 'ID') and ld.[WORKFLOW_CODE] = 'T'
		and
		l.[WORKFLOW_CODE] = 'LT' 
		
	-- update row counts		
	exec CTX.TransformLogTaskInsert 'CTX.DataTerritory', @@rowcount, 'I'
		
END
