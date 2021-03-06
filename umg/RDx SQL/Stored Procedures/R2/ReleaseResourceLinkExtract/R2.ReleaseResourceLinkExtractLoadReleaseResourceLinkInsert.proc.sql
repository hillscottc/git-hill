﻿-- ============================================
-- Description:	Load records from RMS.ReleaseResourceLinkS into R2.LoadReleaseResourceLink
-- =============================================
CREATE PROCEDURE R2.ReleaseResourceLinkExtractLoadReleaseResourceLinkInsert
AS
insert into R2.LoadReleaseResourceLink
select * from 
openquery (R2, 
'
	SELECT 
		R.RELEASE_RESOURCE_LINK_ID, 
		R.AUDIT_DATE_CREATED, 
		R.AUDIT_DATE_CHANGED, 
		R.AUDIT_EMPLOYEE_NO, 
		R.RELEASE_ID, 
		R.RESOURCE_ID, 
		R.PRIMARY_INDICATOR
	FROM 
		RMS.RELEASE_RESOURCE_LINK R,
    	PARTNER.DRIVER_KEY DK
	where
	    R.RELEASE_RESOURCE_LINK_ID = DK.UNIQUE_ID 
		
		AND DK.REPERTOIRE_TYPE = ''RELRES''
		AND DK.GENERIC_STRING = ''P''
')
;


