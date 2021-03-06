﻿-- ============================================
-- Description:	Deletes records form R2.ConfigResourceTypeLink
-- =============================================
CREATE PROCEDURE R2.ConfigResourceTypeLinkDelete 
AS
BEGIN
	update R2.ConfigResourceTypeLink 
	set CHANGE_CODE = 'UD', CHANGE_DATE_TIME = getdate()
	from 
		R2.ConfigResourceTypeLink t
		left outer join R2.LoadConfigResourceTypeLink l 
			on t.CONFIG_ID = l.CONFIG_ID and t.RESOURCE_LOCATION = l.RESOURCE_LOCATION and t.RESOURCE_TYPE = l.RESOURCE_TYPE 
	where
		(l.CONFIG_ID is null) and (l.RESOURCE_LOCATION is null) and (l.RESOURCE_TYPE is null)
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.ConfigResourceTypeLink', @@rowcount, 'D'
		
END
GO
