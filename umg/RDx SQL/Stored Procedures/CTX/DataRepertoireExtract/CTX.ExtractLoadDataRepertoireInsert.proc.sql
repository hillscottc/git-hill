﻿-- ============================================
-- Description:	Loads records from CTX.CONTRAXX.CTV_DATA_REPERTOIRE into CTX.LoadDataRepertoire
-- =============================================
CREATE PROCEDURE CTX.ExtractLoadDataRepertoireInsert(@contractID numeric (38, 0))
AS
begin
	insert into CTX.LoadDataRepertoire
	(
		CONTRACT_ID, 
		REPERTOIRE_TYPE, 
		UNIQUE_ID
	)
	execute 
	('
		SELECT 
			C.CONTRACT_ID, 
			C.REPERTOIRE_TYPE, 
			C.UNIQUE_ID
		FROM 
			CONTRAXX.CTV_DATA_REPERTOIRE C
		WHERE
			C.CONTRACT_ID = ' + @contractID
	) at CTX
end;	


