-- ============================================
-- Description:	Inserts records in R2.LoadContributionDriver
-- =============================================
CREATE PROCEDURE [R2].[ContributionLoadDriver] 
AS
BEGIN

	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into R2.LoadContributionDriver 
	(
		CONTRIBUTION_ID,
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.CONTRIBUTION_ID, 
		'L',
		'I',
		@timestamp 
	from 
		R2.LoadContribution l
		left outer join R2.Contribution t on l.CONTRIBUTION_ID = t.CONTRIBUTION_ID
	where 		
		t.CONTRIBUTION_ID is null
		
	set @rowcount = @rowcount + @@rowcount

-- Updates
	insert into R2.LoadContributionDriver 
	(
		CONTRIBUTION_ID,
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.CONTRIBUTION_ID, 
		'L',
		'U',
		@timestamp 
	from 
		R2.LoadContribution l
		inner join R2.Contribution t on l.CONTRIBUTION_ID = t.CONTRIBUTION_ID
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
END
GO