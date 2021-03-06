﻿-- ============================================
-- Description:	Updates records in CTX.MetaProperty
-- =============================================
CREATE PROCEDURE CTX.MetaPropertyUpdate 
AS
BEGIN
	update CTX.MetaProperty
	set
		[ORGANIZATION_ID] = l.[ORGANIZATION_ID]
		,[TEMPLATE_ID] = l.[TEMPLATE_ID]
		,[FIELD] = l.[FIELD]
		,[NOTES] = l.[NOTES]

		,CHANGE_CODE = N'U'
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		CTX.MetaProperty t
		inner join CTX.LoadMetaProperty l 
			on t.ORGANIZATION_ID = l.ORGANIZATION_ID and t.TEMPLATE_ID = l.TEMPLATE_ID and t.FIELD = l.FIELD
			
	-- update row counts		
	exec CTX.TransformLogTaskInsert 'CTX.MetaProperty', @@rowcount, 'U'
			
END
GO