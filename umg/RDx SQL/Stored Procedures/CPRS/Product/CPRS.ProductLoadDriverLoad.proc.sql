-- =============================================
-- Description:	Inserts records in CPRS.LoadProductDriver
-- =============================================
CREATE PROCEDURE [CPRS].[ProductLoadDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from CPRS.LoadProductDriver where WorkflowCode = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into CPRS.LoadProductDriver 
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
		CPRS.LoadProduct l
		left outer join CPRS.Product t 
			on l.ProductID = t.ProductID
	where 		
		t.ProductID is null
		
	set @rowcount = @rowcount + @@rowcount

-- Updates
	insert into CPRS.LoadProductDriver 
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
		CPRS.LoadProduct l
		inner join CPRS.Product t 
			on l.ProductID = t.ProductID
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
	
END
GO