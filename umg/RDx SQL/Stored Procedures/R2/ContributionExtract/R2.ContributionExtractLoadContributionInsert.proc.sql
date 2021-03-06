﻿-- ============================================
-- Description:	Load records from RMS.Contribution_MASTER into R2.LoadContribution
-- =============================================
CREATE PROCEDURE R2.ContributionExtractLoadContributionInsert
AS
insert into R2.LoadContribution
select * from 
openquery (R2, 
'
	SELECT 
	   C.CONTRIBUTION_ID, 
	   C.UNIQUE_ID, 
	   C.REPERTOIRE_TYPE, 
	   C.ROLE_NO, 
	   C.TALENT_NAME_ID, 
	   C.AUDIT_DATE_CREATED, 
	   C.AUDIT_DATE_CHANGED, 
	   C.AUDIT_EMPLOYEE_NO, 
	   C.LABEL_COPY_CREDIT, 
	   C.SESSION_ID, 
	   C.NOTES, 
	   C.MUSICIAN_CONTRACT_CATEGORY, 
	   C.SEQUENCE_NO, 
	   C.PRIMARY_INDICATOR
	FROM 
		RMS.CONTRIBUTIONS C,
		PARTNER.DRIVER_KEY DK
	where
	    C.CONTRIBUTION_ID = DK.UNIQUE_ID 

		AND (C.REPERTOIRE_TYPE = ''PRODCT'' OR C.REPERTOIRE_TYPE = ''RECORD'')
		
		AND DK.REPERTOIRE_TYPE = ''CONTRI''
		AND DK.GENERIC_STRING = ''P''
')
;


