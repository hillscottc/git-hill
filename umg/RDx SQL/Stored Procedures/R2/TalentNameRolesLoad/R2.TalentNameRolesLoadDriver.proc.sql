-- ============================================
-- Description:	Inserts records in R2.LoadTalentNameRolesDriver
-- =============================================
CREATE PROCEDURE [R2].[TalentNameRolesLoadDriver] 
AS
BEGIN

	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into R2.LoadTalentNameRolesDriver 
	(
		TALENT_NAME_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.TALENT_NAME_ID, 
		'L',
		'I',
		@timestamp 
	from 
		R2.LoadContribution l
		left outer join R2.TalentNameRoles t on l.TALENT_NAME_ID = t.TALENT_NAME_ID
	where 		
		t.TALENT_NAME_ID is null
		
	set @rowcount = @rowcount + @@rowcount

-- Updates
	insert into R2.LoadTalentNameRolesDriver 
	(
		TALENT_NAME_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.TALENT_NAME_ID, 
		'L',
		'U',
		@timestamp 
	from 
		R2.LoadContribution l
		inner join R2.TalentNameRoles t on l.TALENT_NAME_ID = t.TALENT_NAME_ID
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
END
GO