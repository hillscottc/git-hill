-- ============================================
-- Description:	Updates records in CTX.DataRepertoire
-- =============================================
CREATE PROCEDURE CTX.DataRepertoireLoadUpdate
AS
BEGIN
	update CTX.DataRepertoire
	set
		[CONTRACT_ID] = l.[CONTRACT_ID]
		,[REPERTOIRE_TYPE] = l.[REPERTOIRE_TYPE]
		,[UNIQUE_ID] = l.[UNIQUE_ID]
		
		,CHANGE_CODE = ld.CHANGE_CODE
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		CTX.DataRepertoire t
		inner join CTX.LoadDataRepertoire l 
			on t.CONTRACT_ID = l.CONTRACT_ID 
				and t.REPERTOIRE_TYPE = l.REPERTOIRE_TYPE
				and t.UNIQUE_ID = l.UNIQUE_ID
		inner join CTX.LoadDataRepertoireDriver ld 
			on l.CONTRACT_ID = ld.CONTRACT_ID 
				and l.REPERTOIRE_TYPE = ld.REPERTOIRE_TYPE
				and l.UNIQUE_ID = ld.UNIQUE_ID
	where
		(ld.CHANGE_CODE = 'U' or ld.CHANGE_CODE = 'UD') and ld.WORKFLOW_CODE = 'T'
		
	-- update row counts		
	exec CTX.TransformLogTaskInsert 'CTX.DataRepertoire', @@rowcount, 'U'
		
END
