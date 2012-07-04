-- =============================================
-- Description:	Inserts records in CTX.LoadDataContractDriver
-- =============================================
CREATE PROCEDURE [CTX].[DataContractLoadDriverLoad] 
AS
BEGIN

	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from CTX.LoadDataContractDriver where [WORKFLOW_CODE] = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;

	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into CTX.LoadDataContractDriver 
	(
		[CONTRACT_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[CONTRACT_ID],
		'L',
		case when l.[CHANGE_CODE] = 'C' then 'I' else 'ID' end,
		l.CHANGE_DATE_TIME
	from 
		CTX.LoadDataContract l
		left outer join CTX.DataContract t 
			on l.[CONTRACT_ID] = t.[CONTRACT_ID]
	where 
		(t.[CONTRACT_ID] is null)
		and
		(l.[WORKFLOW_CODE] = 'LT')

	set @rowcount = @rowcount + @@rowcount

-- Updates
	insert into CTX.LoadDataContractDriver 
	(
		[CONTRACT_ID],
		[WORKFLOW_CODE],
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.[CONTRACT_ID],
		'L',
		case when l.[CHANGE_CODE] = 'C' then 'U' else 'UD' end,
		l.CHANGE_DATE_TIME
	from 
		CTX.LoadDataContract l
		inner join CTX.DataContract t 
			on l.[CONTRACT_ID] = t.[CONTRACT_ID] 
	where 
		(l.[WORKFLOW_CODE] = 'LT')
		
	set @rowcount = @rowcount + @@rowcount		
	
	return @rowcount
END
GO