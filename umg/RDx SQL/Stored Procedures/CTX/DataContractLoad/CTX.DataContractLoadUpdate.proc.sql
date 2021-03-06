﻿-- =============================================
-- Description:	Updates records in CTX.DataContract
-- =============================================
CREATE PROCEDURE CTX.DataContractLoadUpdate
AS
BEGIN
	update CTX.DataContract
	set
		[ORGANIZATION_ID] = l.[ORGANIZATION_ID]
		,[TEMPLATE_ID] = l.[TEMPLATE_ID]
		,[CONTRACT_ID] = l.[CONTRACT_ID]
		,[CONTRACT_DESC] = l.[CONTRACT_DESC]
		,[CONTRACT_RECORD_TYPE] = l.[CONTRACT_RECORD_TYPE]
		,[CONTRACT_TYPE] = l.[CONTRACT_TYPE]
		,[UNIQUE_CONTRACT_NUMBER] = l.[UNIQUE_CONTRACT_NUMBER]
		,[ARTIST_ID] = l.[ARTIST_ID]
		,[ARTIST] = l.[ARTIST]
		,[CONTRACT_SUMMARY_STATUS] = l.[CONTRACT_SUMMARY_STATUS]
		,[COMPANY_ID] = l.[COMPANY_ID]
		,[COMPANY] = l.[COMPANY]
		,[CONTRACT_EFFECTIVE_DATE] = l.[CONTRACT_EFFECTIVE_DATE]
		,[CURRENT_ARTIST] = l.[CURRENT_ARTIST]
		,[END_OF_TERM_DATE] = l.[END_OF_TERM_DATE]
		,[HEADER_NOTES] = l.[HEADER_NOTES]
		,[RIGHTS_PERIOD] = l.[RIGHTS_PERIOD]
		,[RIGHTS_EXPIRY_DATE] = l.[RIGHTS_EXPIRY_DATE]
		,[RIGHTS_EXPIRY_RULE] = l.[RIGHTS_EXPIRY_RULE]
		,[RIGHTS_PERIOD_NOTES] = l.[RIGHTS_PERIOD_NOTES]
		,[TERRITORIAL_RIGHTS_NOTES] = l.[TERRITORIAL_RIGHTS_NOTES]
				
		,CHANGE_CODE = ld.CHANGE_CODE
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		CTX.DataContract t
		inner join CTX.LoadDataContract l 
			on t.[CONTRACT_ID] = l.[CONTRACT_ID] 
		inner join CTX.LoadDataContractDriver ld 
			on l.[CONTRACT_ID] = ld.[CONTRACT_ID]
	where
		(ld.CHANGE_CODE = 'U' or ld.CHANGE_CODE = 'UD') and ld.[WORKFLOW_CODE] = 'T'
		and 
		l.[WORKFLOW_CODE] = 'LT'
		
	-- update row counts		
	exec CTX.TransformLogTaskInsert 'CTX.DataContract', @@rowcount, 'U'
		
	-- deleted 
	update CTX.DataContract
	set
		CHANGE_CODE = 'UD'
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		CTX.DataContract t
		inner join CTX.DataContractDeleted d 
			on t.CONTRACT_ID = d.CONTRACT_ID 
	where
		(d.WORKFLOW_CODE = 'L')
		
	-- mark the records in DataContractDeleted as completed 	
	update CTX.DataContractDeleted
	set WORKFLOW_CODE = 'C'
	from 
		CTX.DataContractDeleted d 
		inner join CTX.DataContract t
			on d.CONTRACT_ID = t.CONTRACT_ID 
	where
		(d.WORKFLOW_CODE = 'L')
		
	-- update row counts		
	exec CTX.TransformLogTaskInsert 'CTX.DataContract', @@rowcount, 'D'
		
END
