﻿-- ============================================
-- Description:	Loads records from CTX.CONTRAXX.CTV_DATA_TERRITORY into CTX.LoadDataTerritory
-- =============================================
CREATE PROCEDURE CTX.ExtractLoadDataTerritoryInsert(@contractID numeric (38, 0))
AS
begin
	insert into CTX.LoadDataTerritory
	(
		CONTRACT_ID, 
		PROPERTY_NM, 
		UNIQUE_ID, 
		TERRITORY_TYPE, 
		NAME
	)
	execute 
	('
		SELECT 
			C.CONTRACT_ID, 
			C.PROPERTY_NM, 
			C.UNIQUE_ID, 
			C.TERRITORY_TYPE, 
			C.NAME
		FROM 
			CONTRAXX.CTV_DATA_TERRITORY C
		WHERE
			C.CONTRACT_ID = ' + @contractID
	) at CTX
end;	


