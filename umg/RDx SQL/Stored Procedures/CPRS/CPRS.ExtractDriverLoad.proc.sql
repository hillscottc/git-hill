-- =============================================
-- Description:	Inserts records in CPRS.ExtractDriver
-- =============================================
CREATE PROCEDURE [CPRS].[ExtractDriverLoad] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have unprocessed records (i.e. rows with workflow_code = 'E')
	select @existingJobRows = count(*) from CPRS.ExtractDriver where WorkflowCode = 'E'
	if (@existingJobRows > 0)
		return @existingJobRows;

	-- allocate records in 	CPRS.Subscription	
	update CPRS.Subscription set WorkflowCode = 'T' where WorkflowCode = 'E'

	-- insert distinct ProductID in the driver
	insert into CPRS.ExtractDriver
	(
		ProductID, 
		ChangeDatetime, 
		WorkflowCode 
	)
	select 
		ProductID, 
		ChangeDatetime = max(MessageReceiveTime), 
		WorkflowCode = 'E' 
	from 
		CPRS.Subscription
	where 
		WorkflowCode = 'T'
	group by 
		ProductID
		
	-- allocate records in 	CPRS.Subscription	
	update CPRS.Subscription set WorkflowCode = 'C' where WorkflowCode = 'T'
		
	return @@rowcount
END
GO