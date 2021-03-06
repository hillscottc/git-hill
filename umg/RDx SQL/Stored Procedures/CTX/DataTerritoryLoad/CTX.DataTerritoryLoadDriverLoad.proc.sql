﻿-- ============================================
-- Description:	Inserts records in CTX.LoadDataTerritoryDriver
-- =============================================
CREATE PROCEDURE CTX.[DataTerritoryLoadDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from CTX.LoadDataTerritoryDriver where WORKFLOW_CODE = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
	-- New Records
	insert into CTX.LoadDataTerritoryDriver 
	(
		CONTRACT_ID,
		TERRITORY_TYPE,
		UNIQUE_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.CONTRACT_ID,
		l.TERRITORY_TYPE,
		l.UNIQUE_ID,
		'L',
		'I',
		@timestamp 
	from 
		CTX.LoadDataTerritory l
		left outer join CTX.DataTerritory t 
			on t.CONTRACT_ID = l.CONTRACT_ID 
				and t.TERRITORY_TYPE = l.TERRITORY_TYPE
				and t.UNIQUE_ID = l.UNIQUE_ID
	where 		
		(t.CONTRACT_ID is null) and (t.TERRITORY_TYPE is null) and (t.UNIQUE_ID is null)
		and
		l.WORKFLOW_CODE = 'LT'
		
	set @rowcount = @rowcount + @@rowcount

	-- Updates
	insert into CTX.LoadDataTerritoryDriver 
	(
		CONTRACT_ID,
		TERRITORY_TYPE,
		UNIQUE_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		l.CONTRACT_ID,
		l.TERRITORY_TYPE,
		l.UNIQUE_ID,
		'L',
		'U',
		@timestamp 
	from 
		CTX.LoadDataTerritory l
		inner join CTX.DataTerritory t 
			on l.CONTRACT_ID = t.CONTRACT_ID 
				and l.TERRITORY_TYPE = t.TERRITORY_TYPE
				and l.UNIQUE_ID = t.UNIQUE_ID
	where
		l.WORKFLOW_CODE = 'LT'	
		
	set @rowcount = @rowcount + @@rowcount						

	-- Deletes
	insert into CTX.LoadDataTerritoryDriver 
	(
		CONTRACT_ID,
		TERRITORY_TYPE,
		UNIQUE_ID,
		WORKFLOW_CODE,
		CHANGE_CODE,
		CHANGE_DATE_TIME
	)
	select 
		t.CONTRACT_ID,
		t.TERRITORY_TYPE,
		t.UNIQUE_ID,
		'L',
		'UD',
		@timestamp 
	from 
		(
			-- this gets all records in LoadDataTerritory for CONTRACT_ID that also exist in DataTerritory
			select distinct t.CONTRACT_ID, t.TERRITORY_TYPE, t.UNIQUE_ID
			from 
				CTX.DataTerritory t 
				inner join CTX.LoadDataTerritory l
					on t.CONTRACT_ID = l.CONTRACT_ID
			where 
				l.WORKFLOW_CODE = 'LT'					
		)as t
		-- left join to LoadDataTerritory on all fields to see which records are not in LoadDataTerritory
		-- those records will have to be deleted from DataTerritory
		left outer join CTX.LoadDataTerritory l 
			on t.CONTRACT_ID = l.CONTRACT_ID 
				and t.TERRITORY_TYPE = l.TERRITORY_TYPE
				and t.UNIQUE_ID = l.UNIQUE_ID
	where
		(l.CONTRACT_ID is null) and (l.TERRITORY_TYPE is null) and (l.UNIQUE_ID is null)
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
	
END
GO