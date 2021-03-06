﻿-- =============================================
-- Description:	Inserts records in CPRS.LoadDigitalProductLocalDriver
-- =============================================
CREATE PROCEDURE [CPRS].[DigitalProductLocalLoadDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from CPRS.LoadDigitalProductLocalDriver where WorkflowCode = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;

	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into CPRS.LoadDigitalProductLocalDriver 
	(
		ProductID,
		CountryISO,
		WorkflowCode,
		ChangeCode,
		ChangeDatetime
	)
	select 
		l.ProductID, 
		l.CountryISO,
		'L',
		'I',
		@timestamp
	from 
		CPRS.LoadDigitalProductLocal l
		left outer join CPRS.DigitalProductLocal t 
			on l.ProductID = t.ProductID and l.CountryISO = t.CountryISO
	where 		
		(t.ProductID is null) and (t.CountryISO is null)
		
	set @rowcount = @rowcount + @@rowcount

-- Updates
	insert into CPRS.LoadDigitalProductLocalDriver 
	(
		ProductID,
		CountryISO,
		WorkflowCode,
		ChangeCode,
		ChangeDatetime
	)
	select 
		l.ProductID, 
		l.CountryISO,
		'L',
		'U',
		@timestamp
	from 
		CPRS.LoadDigitalProductLocal l
		inner join CPRS.DigitalProductLocal t 
			on l.ProductID = t.ProductID and l.CountryISO = t.CountryISO
		
	set @rowcount = @rowcount + @@rowcount		
	
	-- Deletes
	insert into CPRS.LoadDigitalProductLocalDriver 
	(
		ProductID,
		CountryISO,
		WorkflowCode,
		ChangeCode,
		ChangeDatetime
	)
	select 
		t.ProductID,
		t.CountryISO,
		'L',
		'UD',
		@timestamp 
	from 
		(
			-- this gets all records in LoadDigitalProductLocal for ProductID that exist in DigitalProductLocal
			select distinct t.ProductID, t.CountryISO 
			from 
				CPRS.DigitalProductLocal t 
				inner join CPRS.LoadDigitalProductLocal l
					on t.ProductID = l.ProductID
			where 
				l.Workflowcode = 'LT'					
		)as t
		-- left join to LoadDigitalProductLocal to see which records are not in LoadDigitalProductLocal
		-- those records will have to be deleted from DigitalProductLocal
		left outer join CPRS.LoadDigitalProductLocal l 
			on t.ProductID = l.ProductID and t.CountryISO = l.CountryISO
	where
		(l.ProductID is null) and (l.CountryISO is null)

	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
	
END
GO