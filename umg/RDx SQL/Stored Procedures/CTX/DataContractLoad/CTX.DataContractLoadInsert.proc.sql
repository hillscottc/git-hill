﻿-- =============================================
-- Description:	Inserts records in CTX.DataContract
-- =============================================
CREATE PROCEDURE [CTX].[DataContractLoadInsert] 
AS
BEGIN
	insert into CTX.DataContract
	select 
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
		CTX.LoadDataContract l 
		inner join CTX.LoadDataContractDriver ld 
			on l.[CONTRACT_ID] = ld.[CONTRACT_ID]
	where 
		(ld.CHANGE_CODE = 'I' or ld.CHANGE_CODE = 'ID') and ld.[WORKFLOW_CODE] = 'T'
		and
		l.[WORKFLOW_CODE] = 'LT' 
		
	-- update row counts		
	exec CTX.TransformLogTaskInsert 'CTX.DataContract', @@rowcount, 'I'
		
END
