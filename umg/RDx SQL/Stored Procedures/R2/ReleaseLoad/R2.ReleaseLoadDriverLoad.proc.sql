-- ============================================
-- Description:	Inserts records in R2.LoadReleaseDriver
-- =============================================
CREATE PROCEDURE [R2].[ReleaseLoadDriverLoad] 
AS
BEGIN

	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from R2.LoadReleaseDriver where [WORKFLOW_CODE] = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;

	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into R2.LoadReleaseDriver 
	(
		[RELEASE_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[RELEASE_ID],
		'L',
		case when l.[CHANGE_CODE] = 'C' then 'I' else 'ID' end,
		l.CHANGE_DATE_TIME
	from 
		R2.LoadRelease l
		left outer join R2.Release t 
			on l.[RELEASE_ID] = t.[RELEASE_ID]
	where 
		(t.[RELEASE_ID] is null)
		and
		(l.[WORKFLOW_CODE] = 'LT')

	set @rowcount = @rowcount + @@rowcount

-- Updates
	insert into R2.LoadReleaseDriver 
	(
		[RELEASE_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[RELEASE_ID],
		'L',
		case when l.[CHANGE_CODE] = 'C' then 'U' else 'UD' end,
		l.CHANGE_DATE_TIME
	from 
		R2.LoadRelease l
		inner join R2.Release t 
			on l.[RELEASE_ID] = t.[RELEASE_ID] 
	where 
		(l.[WORKFLOW_CODE] = 'LT')
		
	set @rowcount = @rowcount + @@rowcount		
	
	return @rowcount
END
GO