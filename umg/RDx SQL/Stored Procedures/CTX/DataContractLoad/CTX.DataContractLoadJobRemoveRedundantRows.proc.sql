﻿-- =============================================
-- Description:	Clears duplicate rows from CTX.LoadDataContract. 
-- =============================================
CREATE PROCEDURE [CTX].[DataContractLoadJobRemoveRedundantRows] 
AS
BEGIN

	-- Clean records with the same "CONTRACT_ID" and different change datetime.
	delete CTX.LoadDataContract
	from 
		CTX.LoadDataContract r
		inner join
		(
			-- finds duplicate CONTRACT_ID
			select CONTRACT_ID, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME) 
			from CTX.LoadDataContract 
			where [WORKFLOW_CODE] = 'LT'
			group by CONTRACT_ID having count(*) > 1
		) as t
		on 
			r.CONTRACT_ID = t.CONTRACT_ID 
		where
			CHANGE_DATE_TIME <> t.MAX_CHANGE_DATE_TIME
			
	-- Clean records with duplicate "CONTRACT_ID"
	delete CTX.LoadDataContract
	from 
		CTX.LoadDataContract r
		inner join
		(
			-- finds duplicate CONTRACT_ID
			select CONTRACT_ID, MAX_ID = max(ID) 
			from CTX.LoadDataContract 
			where [WORKFLOW_CODE] = 'LT'
			group by CONTRACT_ID having count(*) > 1
		) as t
		on 
			r.CONTRACT_ID = t.CONTRACT_ID 
		where
			ID <> t.MAX_ID			
			
END
GO