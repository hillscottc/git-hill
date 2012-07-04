-- ============================================
-- Description:	Inserts records in R2.LoadResourceLocalDriver
-- =============================================
CREATE PROCEDURE [R2].[ResourceLoadDriverLoadLocal] 
AS
BEGIN

	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from R2.LoadResourceLocalDriver where [WORKFLOW_CODE] = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;

	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into R2.LoadResourceLocalDriver 
	(
		[Resource_ID],
		[COMPANY_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[Resource_ID],
		l.[COMPANY_ID],
		'L',
		case when l.[CHANGE_CODE] = 'C' then 'I' else 'ID' end,
		l.CHANGE_DATE_TIME
	from 
		R2.LoadResourceLocal l
		left outer join R2.ResourceLocal t 
			on l.[Resource_ID] = t.[Resource_ID] and l.[COMPANY_ID] = t.[COMPANY_ID] 
	where 
		(t.[Resource_ID] is null and t.[COMPANY_ID] is null)
		and
		(l.[WORKFLOW_CODE] = 'LT')

	set @rowcount = @rowcount + @@rowcount

-- Updates
	insert into R2.LoadResourceLocalDriver 
	(
		[Resource_ID],
		[COMPANY_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[Resource_ID],
		l.[COMPANY_ID],
		'L',
		case when l.[CHANGE_CODE] = 'C' then 'U' else 'UD' end,
		l.CHANGE_DATE_TIME
	from 
		R2.LoadResourceLocal l
		inner join R2.ResourceLocal t 
			on l.[Resource_ID] = t.[Resource_ID] and l.[COMPANY_ID] = t.[COMPANY_ID] 
	where 
		(l.[WORKFLOW_CODE] = 'LT')
		
	set @rowcount = @rowcount + @@rowcount		
	

	return @rowcount
END
GO