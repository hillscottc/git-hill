﻿-- =============================================
-- Description:	Inserts records in CPRS.LoadProductTerritoryRightDriver
-- =============================================
CREATE PROCEDURE [CPRS].[ProductTerritoryRightLoadDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from CPRS.LoadProductTerritoryRightDriver where WorkflowCode = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;

	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into CPRS.LoadProductTerritoryRightDriver 
	(
		ProductID,
		ProductMedium,
		ISO,			
		WorkflowCode,
		ChangeCode,
		ChangeDatetime
	)
	select 
		l.ProductID, 
		l.ProductMedium,
		l.ISO,
		'L',
		'I',
		@timestamp
	from 
		CPRS.LoadProductTerritoryRight l
		left outer join CPRS.ProductTerritoryRight t 
			on l.ProductMedium = t.ProductMedium and l.ProductID = t.ProductID and l.ISO = t.ISO
	where 		
		(t.ProductMedium is null) and (t.ProductID is null) and (t.ISO is null)
		
	set @rowcount = @rowcount + @@rowcount

-- Updates
	insert into CPRS.LoadProductTerritoryRightDriver 
	(
		ProductID,
		ProductMedium,
		ISO,
		WorkflowCode,
		ChangeCode,
		ChangeDatetime
	)
	select 
		l.ProductID, 
		l.ProductMedium,
		l.ISO,
		'L',
		'U',
		@timestamp
	from 
		CPRS.LoadProductTerritoryRight l
		inner join CPRS.ProductTerritoryRight t 
			on l.ProductMedium = t.ProductMedium and l.ProductID = t.ProductID and l.ISO = t.ISO
		
	set @rowcount = @rowcount + @@rowcount		
	
	-- Deletes
	insert into CPRS.LoadProductTerritoryRightDriver 
	(
		ProductID,
		ProductMedium,
		ISO,		
		WorkflowCode,
		ChangeCode,
		ChangeDatetime
	)
	select 
		t.ProductID, 
		t.ProductMedium,
		t.ISO,
		'L',
		'UD',
		@timestamp 
	from 
		(
			-- this gets all records in LoadProductTerritoryRight for ProductID that exist in ProductTerritoryRight
			select distinct t.ProductID, t.ISO, t.ProductMedium 
			from 
				CPRS.ProductTerritoryRight t 
				inner join CPRS.LoadProductTerritoryRight l
					on t.ProductID = l.ProductID
			where 
				l.Workflowcode = 'LT'					
		)as t
		-- left join to LoadProductTerritoryRight to see which records are not in LoadProductTerritoryRight
		-- those records will have to be deleted from ProductTerritoryRight
		left outer join CPRS.LoadProductTerritoryRight l 
			on t.ProductMedium = l.ProductMedium and t.ProductID = l.ProductID and t.ISO = l.ISO
	where
		(l.ProductMedium is null) and (l.ProductID is null) and (l.ISO is null)

	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
	
END
GO