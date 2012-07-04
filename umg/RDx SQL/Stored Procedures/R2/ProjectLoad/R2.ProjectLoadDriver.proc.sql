-- ============================================
-- Description:	Inserts records in R2.LoadProjectDriver
-- =============================================
CREATE PROCEDURE [R2].[ProjectLoadDriver] 
AS
BEGIN

	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into R2.LoadProjectDriver 
	(
		PROJECT_ID,
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.PROJECT_ID, 
		'L',
		'I',
		@timestamp 
	from 
		R2.LoadProject l
		left outer join R2.Project t on l.PROJECT_ID = t.PROJECT_ID
	where 		
		t.PROJECT_ID is null
		
	set @rowcount = @rowcount + @@rowcount

-- Updates
	insert into R2.LoadProjectDriver 
	(
		PROJECT_ID,
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.PROJECT_ID, 
		'L',
		'U',
		@timestamp 
	from 
		R2.LoadProject l
		inner join R2.Project t on l.PROJECT_ID = t.PROJECT_ID
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
END
GO