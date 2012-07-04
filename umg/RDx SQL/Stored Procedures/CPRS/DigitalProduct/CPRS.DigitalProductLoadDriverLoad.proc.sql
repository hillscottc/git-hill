CREATE PROCEDURE [CPRS].[DigitalProductLoadDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from CPRS.LoadDigitalProductDriver where WorkflowCode = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;

	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
	-- New Records
	insert into CPRS.LoadDigitalProductDriver 
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
		CPRS.LoadDigitalProduct l
		left outer join CPRS.DigitalProduct t 
			on l.ProductID = t.ProductID
	where 		
		t.ProductID is null
		
	set @rowcount = @rowcount + @@rowcount

	-- Updates
	insert into CPRS.LoadDigitalProductDriver 
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
		CPRS.LoadDigitalProduct l
		inner join CPRS.DigitalProduct t 
			on l.ProductID = t.ProductID
		
	set @rowcount = @rowcount + @@rowcount		
	
	-- Deletes
	insert into CPRS.LoadDigitalProductDriver 
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
			-- this gets all records in LoadDigitalProduct for UPC that exist in DigitalProduct
			select distinct t.ProductID
			from 
				CPRS.DigitalProduct t 
				inner join CPRS.LoadDigitalProduct l
					on t.ProductID = l.ProductID
			where 
				l.Workflowcode = 'LT'					
		)as t
		-- left join to LoadDigitalProduct to see which records are not in LoadDigitalProduct
		-- those records will have to be deleted from DigitalProduct
		left outer join CPRS.LoadDigitalProduct l 
			on t.ProductID = l.ProductID
	where
		(l.ProductID is null)

	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
	
END
GO