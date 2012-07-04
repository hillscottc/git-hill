-- ============================================
-- Description:	Updates records in R2.ConfigResourceTypeLink
-- =============================================
CREATE PROCEDURE R2.ConfigResourceTypeLinkUpdate 
AS
BEGIN
	update R2.ConfigResourceTypeLink
	set
		CONFIG_ID = l.CONFIG_ID, 
		RESOURCE_LOCATION = l.RESOURCE_LOCATION, 
		RESOURCE_TYPE = l.RESOURCE_TYPE, 
		AVAILABILITY_CHECK_REQUIRED = l.AVAILABILITY_CHECK_REQUIRED,
			
		CHANGE_CODE = N'U', 
		CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		R2.ConfigResourceTypeLink t
		inner join R2.LoadConfigResourceTypeLink l 
			on t.CONFIG_ID = l.CONFIG_ID and t.RESOURCE_LOCATION = l.RESOURCE_LOCATION and t.RESOURCE_TYPE = l.RESOURCE_TYPE
			
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.ConfigResourceTypeLink', @@rowcount, 'U'
			
END
GO