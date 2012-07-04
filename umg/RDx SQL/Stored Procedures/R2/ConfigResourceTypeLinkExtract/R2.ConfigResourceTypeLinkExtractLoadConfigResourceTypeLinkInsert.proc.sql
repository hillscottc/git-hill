-- ============================================
-- Description:	Load records from RMS.CONFIG_RESOURCE_TYPE_LINK into R2.LoadConfigResourceTypeLink
-- =============================================
CREATE PROCEDURE R2.ConfigResourceTypeLinkExtractLoadConfigResourceTypeLinkInsert
AS
	insert into R2.LoadConfigResourceTypeLink
	select * 
	from openquery 
	(R2, 
	'
		SELECT 
			C.CONFIG_ID, 
			C.RESOURCE_LOCATION, 
			C.RESOURCE_TYPE, 
			C.AVAILABILITY_CHECK_REQUIRED
		FROM 
			RMS.CONFIG_RESOURCE_TYPE_LINK C
	');


