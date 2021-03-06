﻿-- ============================================
-- Description:	Inserts records in CTX.DataRepertoire
-- =============================================
CREATE PROCEDURE CTX.[DataRepertoireLoadInsert] 
AS
BEGIN
	insert into CTX.DataRepertoire
	select 
		[CONTRACT_ID] = l.[CONTRACT_ID]
		,[REPERTOIRE_TYPE] = l.[REPERTOIRE_TYPE]
		,[UNIQUE_ID] = l.[UNIQUE_ID]

		,CHANGE_CODE = ld.CHANGE_CODE 
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		CTX.LoadDataRepertoire l 
		inner join CTX.LoadDataRepertoireDriver ld 
			on l.CONTRACT_ID = ld.CONTRACT_ID 
				and l.REPERTOIRE_TYPE = ld.REPERTOIRE_TYPE
				and l.UNIQUE_ID = ld.UNIQUE_ID
	where 
		(ld.CHANGE_CODE = 'I' or ld.CHANGE_CODE = 'ID') and ld.[WORKFLOW_CODE] = 'T'
		and
		l.[WORKFLOW_CODE] = 'LT' 
		
	-- update row counts		
	exec CTX.TransformLogTaskInsert 'CTX.DataRepertoire', @@rowcount, 'I'
		
END
