﻿-- ============================================
-- Description:	Inserts records in R2.ConfigResourceTypeLink
-- =============================================
CREATE PROCEDURE R2.ConfigResourceTypeLinkInsert 
AS
BEGIN
	insert into R2.ConfigResourceTypeLink
	select 
		l.*, 
		CHANGE_CODE = N'I', 
		CHANGE_DATE_TIME = getdate(),
		WORKFLOW_CODE = 'L'
	from 
		R2.ConfigResourceTypeLink t
		right outer join R2.LoadConfigResourceTypeLink l 
			on t.CONFIG_ID = l.CONFIG_ID and t.RESOURCE_LOCATION = l.RESOURCE_LOCATION and t.RESOURCE_TYPE = l.RESOURCE_TYPE
	where
		(t.CONFIG_ID is null) and (t.RESOURCE_LOCATION is null) and (t.RESOURCE_TYPE is null)
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.ConfigResourceTypeLink', @@rowcount, 'I'
		
END
GO