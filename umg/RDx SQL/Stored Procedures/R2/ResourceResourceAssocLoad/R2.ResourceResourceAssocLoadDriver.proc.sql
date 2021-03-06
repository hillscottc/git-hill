﻿-- ============================================
-- Description:	Inserts records in R2.LoadResourceResourceAssocDriver
-- =============================================
CREATE PROCEDURE [R2].[ResourceResourceAssocLoadDriver] 
AS
BEGIN

	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into R2.LoadResourceResourceAssocDriver 
	(
		RESOURCE_RESOURCE_ASSOC_ID,
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.RESOURCE_RESOURCE_ASSOC_ID, 
		'L',
		'I',
		@timestamp 
	from 
		R2.LoadResourceResourceAssoc l
		left outer join R2.ResourceResourceAssoc t on l.RESOURCE_RESOURCE_ASSOC_ID = t.RESOURCE_RESOURCE_ASSOC_ID
	where 		
		t.RESOURCE_RESOURCE_ASSOC_ID is null
		
	set @rowcount = @rowcount + @@rowcount

-- Updates
	insert into R2.LoadResourceResourceAssocDriver 
	(
		RESOURCE_RESOURCE_ASSOC_ID,
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.RESOURCE_RESOURCE_ASSOC_ID, 
		'L',
		'U',
		@timestamp 
	from 
		R2.LoadResourceResourceAssoc l
		inner join R2.ResourceResourceAssoc t on l.RESOURCE_RESOURCE_ASSOC_ID = t.RESOURCE_RESOURCE_ASSOC_ID
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
END
GO