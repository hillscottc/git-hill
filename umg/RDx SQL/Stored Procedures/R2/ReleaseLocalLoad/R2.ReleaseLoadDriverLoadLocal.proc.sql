-- ============================================
-- Description:	Inserts records in R2.LoadReleaseLocalDriver
-- =============================================
CREATE PROCEDURE [R2].[ReleaseLoadDriverLoadLocal] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from R2.LoadReleaseLocalDriver where [WORKFLOW_CODE] = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;

	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into R2.LoadReleaseLocalDriver 
	(
		[RELEASE_ID],
		[COMPANY_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[RELEASE_ID],
		l.[COMPANY_ID],
		'L',
		case when l.[CHANGE_CODE] = 'C' then 'I' else 'ID' end,
		l.CHANGE_DATE_TIME
	from 
		R2.LoadReleaseLocal l
		left outer join R2.ReleaseLocal t 
			on l.[RELEASE_ID] = t.[RELEASE_ID] and l.[COMPANY_ID] = t.[COMPANY_ID] 
	where 
		(t.[RELEASE_ID] is null and t.[COMPANY_ID] is null)
		and
		(l.[WORKFLOW_CODE] = 'LT')

	set @rowcount = @rowcount + @@rowcount

-- Updates
	insert into R2.LoadReleaseLocalDriver 
	(
		[RELEASE_ID],
		[COMPANY_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[RELEASE_ID],
		l.[COMPANY_ID],
		'L',
		case when l.[CHANGE_CODE] = 'C' then 'U' else 'UD' end,
		l.CHANGE_DATE_TIME
	from 
		R2.LoadReleaseLocal l
		inner join R2.ReleaseLocal t 
			on l.[RELEASE_ID] = t.[RELEASE_ID] and l.[COMPANY_ID] = t.[COMPANY_ID] 
	where 
		(l.[WORKFLOW_CODE] = 'LT')
		
	set @rowcount = @rowcount + @@rowcount		
	
	return @rowcount
END
GO