-- ============================================
-- Description:	Load records from CONTRAXX.CTV_META_PROPERTY into CTX.LoadMetaProperty
-- =============================================
CREATE PROCEDURE CTX.ExtractLoadMetaPropertyInsert
AS
	insert into CTX.LoadMetaProperty
	select * 
	from openquery 
	(CTX, 
	'
		SELECT 
			C.ORGANIZATION_ID, 
			C.TEMPLATE_ID, 
			C.FIELD, 
			C.NOTES
		FROM 
			CONTRAXX.CTV_META_PROPERTY C
	');


