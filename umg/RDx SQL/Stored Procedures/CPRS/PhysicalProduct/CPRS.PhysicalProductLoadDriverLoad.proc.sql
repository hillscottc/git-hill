﻿-- =============================================
-- Description:	Inserts records in CPRS.LoadPhysicalProductDriver
-- =============================================
CREATE PROCEDURE [CPRS].[PhysicalProductLoadDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from CPRS.LoadPhysicalProductDriver where WorkflowCode = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into CPRS.LoadPhysicalProductDriver 
	(
		ProductID,
		WorkflowCode,
		ChangeCode,
		ChangeDatetime
	)
	select 
		l.ProductID, 
		'L',
		'I',
		@timestamp
	from 
		CPRS.LoadPhysicalProduct l
		left outer join CPRS.PhysicalProduct t 
			on l.ProductID = t.ProductID
	where 		
		t.ProductID is null
		
	set @rowcount = @rowcount + @@rowcount

-- Updates
	insert into CPRS.LoadPhysicalProductDriver 
	(
		ProductID,
		WorkflowCode,
		ChangeCode,
		ChangeDatetime
	)
	select 
		l.ProductID, 
		'L',
		'U',
		@timestamp
	from 
		CPRS.LoadPhysicalProduct l
		inner join CPRS.PhysicalProduct t 
			on l.ProductID = t.ProductID
		
	set @rowcount = @rowcount + @@rowcount		
	
	-- Deletes
	insert into CPRS.LoadPhysicalProductDriver 
	(
		ProductID,
		WorkflowCode,
		ChangeCode,
		ChangeDatetime
	)
	select 
		t.ProductID,
		'L',
		'UD',
		@timestamp 
	from 
		(
			-- this gets all records in LoadPhysicalProduct for UPC that exist in PhysicalProduct
			select distinct t.ProductID
			from 
				CPRS.PhysicalProduct t 
				inner join CPRS.LoadPhysicalProduct l
					on t.ProductID = l.ProductID
			where 
				l.Workflowcode = 'LT'					
		)as t
		-- left join to LoadPhysicalProduct to see which records are not in LoadPhysicalProduct
		-- those records will have to be deleted from PhysicalProduct
		left outer join CPRS.LoadPhysicalProduct l 
			on t.ProductID = l.ProductID
	where
		(l.ProductID is null)

	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
	
END
GO