-- ============================================
-- Description:	Inserts records in CTX.LoadDataRepertoireDriver
-- =============================================
CREATE PROCEDURE CTX.[DataRepertoireLoadDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from CTX.LoadDataRepertoireDriver where WORKFLOW_CODE = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
	-- New Records
	insert into CTX.LoadDataRepertoireDriver 
	(
		CONTRACT_ID,
		REPERTOIRE_TYPE,
		UNIQUE_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.CONTRACT_ID,
		l.REPERTOIRE_TYPE,
		l.UNIQUE_ID,
		'L',
		'I',
		@timestamp 
	from 
		CTX.LoadDataRepertoire l
		left outer join CTX.DataRepertoire t 
			on t.CONTRACT_ID = l.CONTRACT_ID 
				and t.REPERTOIRE_TYPE = l.REPERTOIRE_TYPE
				and t.UNIQUE_ID = l.UNIQUE_ID
	where 		
		(t.CONTRACT_ID is null) and (t.REPERTOIRE_TYPE is null) and (t.UNIQUE_ID is null)
		and
		l.WORKFLOW_CODE = 'LT'
		
	set @rowcount = @rowcount + @@rowcount

	-- Updates
	insert into CTX.LoadDataRepertoireDriver 
	(
		CONTRACT_ID,
		REPERTOIRE_TYPE,
		UNIQUE_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.CONTRACT_ID,
		l.REPERTOIRE_TYPE,
		l.UNIQUE_ID,
		'L',
		'U',
		@timestamp 
	from 
		CTX.LoadDataRepertoire l
		inner join CTX.DataRepertoire t 
			on l.CONTRACT_ID = t.CONTRACT_ID 
				and l.REPERTOIRE_TYPE = t.REPERTOIRE_TYPE
				and l.UNIQUE_ID = t.UNIQUE_ID
	where
		l.WORKFLOW_CODE = 'LT'	
		
	set @rowcount = @rowcount + @@rowcount						

	-- Deletes
	insert into CTX.LoadDataRepertoireDriver 
	(
		CONTRACT_ID,
		REPERTOIRE_TYPE,
		UNIQUE_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		t.CONTRACT_ID,
		t.REPERTOIRE_TYPE,
		t.UNIQUE_ID,
		'L',
		'UD',
		@timestamp 
	from 
		(
			-- this gets all records in LoadDataRepertoire for CONTRACT_ID that also exist in DataRepertoire
			select distinct t.CONTRACT_ID, t.REPERTOIRE_TYPE, t.UNIQUE_ID
			from 
				CTX.DataRepertoire t 
				inner join CTX.LoadDataRepertoire l
					on t.CONTRACT_ID = l.CONTRACT_ID
			where 
				l.WORKFLOW_CODE = 'LT'					
		)as t
		-- left join to LoadDataRepertoire on all fields to see which records are not in LoadDataRepertoire
		-- those records will have to be deleted from DataRepertoire
		left outer join CTX.LoadDataRepertoire l 
			on t.CONTRACT_ID = l.CONTRACT_ID 
				and t.REPERTOIRE_TYPE = l.REPERTOIRE_TYPE
				and t.UNIQUE_ID = l.UNIQUE_ID
	where
		(l.CONTRACT_ID is null) and (l.REPERTOIRE_TYPE is null) and (l.UNIQUE_ID is null)
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
	
END
GO