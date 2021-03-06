﻿-- ============================================
-- Description:	Deletes records form CTX.MetaProperty
-- =============================================
CREATE PROCEDURE CTX.MetaPropertyDelete 
AS
BEGIN
	update CTX.MetaProperty 
	set CHANGE_CODE = 'UD', CHANGE_DATE_TIME = getdate()
	from 
		CTX.MetaProperty t
		left outer join CTX.LoadMetaProperty l 
			on t.ORGANIZATION_ID = l.ORGANIZATION_ID and t.TEMPLATE_ID = l.TEMPLATE_ID and t.FIELD = l.FIELD
	where
		(l.ORGANIZATION_ID is null) and (l.TEMPLATE_ID is null) and (l.FIELD is null)
		
	-- update row counts		
	exec CTX.TransformLogTaskInsert 'CTX.MetaProperty', @@rowcount, 'D'
		
END
GO
