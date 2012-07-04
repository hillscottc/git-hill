-- ============================================
-- Description:	Inserts records in R2.LoadTalentNameDriver
-- =============================================
CREATE PROCEDURE [R2].[TalentNameLoadDriver] 
AS
BEGIN

	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into R2.LoadTalentNameDriver 
	(
		TALENT_NAME_ID,
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.TALENT_NAME_ID, 
		'L',
		'I',
		@timestamp 
	from 
		R2.LoadTalentName l
		left outer join R2.TalentName t 
			on l.TALENT_NAME_ID = t.TALENT_NAME_ID
	where			
		t.TALENT_NAME_ID is null

	set @rowcount = @rowcount + @@rowcount

-- Updates
	insert into R2.LoadTalentNameDriver 
	(
		TALENT_NAME_ID,
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.TALENT_NAME_ID, 
		'L',
		'U',
		@timestamp 
	from 
		R2.LoadTalentName l
		inner join R2.TalentName t on l.TALENT_NAME_ID = t.TALENT_NAME_ID
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
END
GO