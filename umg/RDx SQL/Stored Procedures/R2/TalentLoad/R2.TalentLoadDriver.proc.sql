﻿-- ============================================
-- Description:	Inserts records in R2.LoadTalentDriver
-- =============================================
CREATE PROCEDURE [R2].[TalentLoadDriver] 
AS
BEGIN

	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into R2.LoadTalentDriver 
	(
		TALENT_ID,
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.TALENT_ID, 
		'L',
		'I',
		@timestamp 
	from 
		R2.LoadTalent l
		left outer join R2.Talent t 
			on l.TALENT_ID = t.TALENT_ID
	where 		
		t.TALENT_ID is null

	set @rowcount = @rowcount + @@rowcount

-- Updates
	insert into R2.LoadTalentDriver 
	(
		TALENT_ID,
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.Talent_ID, 
		'L',
		'U',
		@timestamp 
	from 
		R2.LoadTalent l
		inner join R2.Talent t on l.Talent_ID = t.Talent_ID
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
END
GO