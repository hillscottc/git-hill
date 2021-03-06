﻿-- ============================================
-- Description:	Load records from RMS.TALENTS into R2.LoadTalent
-- =============================================
CREATE PROCEDURE R2.TalentExtractLoadTalentInsert
AS
insert into R2.LoadTalent
select * from 
openquery (R2, 
'
	SELECT 
		T.TALENT_ID, 
		T.COMPANY_ID, 
		T.TALENT_TYPE, 
		T.AUDIT_DATE_CREATED, 
		T.AUDIT_DATE_CHANGED, 
		T.AUDIT_EMPLOYEE_NO, 		 
		T.COUNTRY_ID, 
		T.DATE_OF_BIRTH_YEAR, 
		T.DATE_OF_DEATH_YEAR, 
		T.RIGHTS_TYPE, 
		T.ACCOUNT_ID,
		T.DQ_STATUS
	FROM 
		RMS.TALENTS T,
    	PARTNER.DRIVER_KEY DK
	where
	    T.TALENT_ID = DK.UNIQUE_ID 
		
		AND DK.REPERTOIRE_TYPE = ''TALENT''
		AND DK.GENERIC_STRING = ''P''
')
;


