-- ============================================
-- Description:	Load records from RMS.RESOURCE_RESOURCE_ASSOC into R2.LoadResourceResourceAssoc
-- =============================================
CREATE PROCEDURE R2.ResourceResourceAssocExtractLoadResourceResourceAssocInsert
AS
insert into R2.LoadResourceResourceAssoc
select * from 
openquery (R2, 
'
	SELECT 
		R.RESOURCE_RESOURCE_ASSOC_ID, 
		R.RESOURCE_COMPANY_LINK_ID, 
		R.RESOURCE_ID, 
		R.AUDIT_DATE_CREATED, 
		R.AUDIT_DATE_CHANGED, 
		R.AUDIT_EMPLOYEE_NO
	FROM 
		RMS.RESOURCE_RESOURCE_ASSOC R,
		PARTNER.DRIVER_KEY DK
	where
	    R.RESOURCE_RESOURCE_ASSOC_ID = DK.UNIQUE_ID 
		
		AND DK.REPERTOIRE_TYPE = ''RSRSAS''
		AND DK.GENERIC_STRING = ''P''
')
;


