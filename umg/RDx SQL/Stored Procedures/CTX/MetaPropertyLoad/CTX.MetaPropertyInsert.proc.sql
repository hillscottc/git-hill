﻿-- ============================================
-- Description:	Inserts records in CTX.MetaProperty
-- =============================================
CREATE PROCEDURE CTX.MetaPropertyInsert 
AS
BEGIN
	insert into CTX.MetaProperty
	select 
		[ORGANIZATION_ID] = l.[ORGANIZATION_ID],
		[TEMPLATE_ID] = l.[TEMPLATE_ID],
		[FIELD] = l.[FIELD],
		[NOTES] = l.[NOTES],
		
		CHANGE_CODE = N'I', 
		CHANGE_DATE_TIME = getdate(),
		WORKFLOW_CODE = 'L'
	from 
		CTX.MetaProperty t
		right outer join CTX.LoadMetaProperty l 
			on t.ORGANIZATION_ID = l.ORGANIZATION_ID and t.TEMPLATE_ID = l.TEMPLATE_ID and t.FIELD = l.FIELD
	where
		(t.ORGANIZATION_ID is null) and (t.TEMPLATE_ID is null) and (t.FIELD is null)
		
	-- update row counts		
	exec CTX.TransformLogTaskInsert 'CTX.MetaProperty', @@rowcount, 'I'
		
END
GO