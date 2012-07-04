-- ============================================
-- Description:	Load records from RMS.TALENT_NAMES into R2.LoadTalentName
-- =============================================
CREATE PROCEDURE R2.TalentNameExtractLoadTalentNameInsert
AS
insert into R2.LoadTalentName
select * from 
openquery (R2, 
'
	SELECT 
		T.TALENT_NAME_ID, 
		T.TALENT_ID, 
		T.LAST_NAME, 
		T.AUDIT_DATE_CREATED, 
		T.AUDIT_DATE_CHANGED, 
		T.AUDIT_EMPLOYEE_NO, 
		T.DQ_STATUS, 
		T.TITLE, 
		T.FIRST_NAME, 
		T.LAST_NAME_PREFIX, 
		T.ABBREVIATED_NAME, 
		T.SEARCH_INFORMATION, 
		T.PARENT_TALENT_NAME_ID, 
		T.COUNTRY_ID, 
		T.DISPLAY_NAME,
		RMS.PKG_TALENT.F_FORMATTED_NAME(T.TITLE, T.FIRST_NAME, T.LAST_NAME_PREFIX, T.LAST_NAME, T.DISPLAY_NAME) FORMATTED_NAME		
	FROM 
		RMS.TALENT_NAMES T,
		PARTNER.DRIVER_KEY DK
	where
	    T.TALENT_NAME_ID = DK.UNIQUE_ID 
		
		AND DK.REPERTOIRE_TYPE = ''TALNAM''
		AND DK.GENERIC_STRING = ''P''
')
;


