﻿-- ============================================
-- Description:	Inserts records in MP.LoadReleaseDriver
-- =============================================
CREATE PROCEDURE [MP].[ReleaseLoadDriverLoad] 
AS
BEGIN

	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have loaded records (i.e. rows with workflow_code = 'L')
	select @existingJobRows = count(*) from MP.LoadReleaseDriver where WorkflowCode = 'L'
	if (@existingJobRows > 0)
		return @existingJobRows;
		
	declare @timestamp datetime
	set @timestamp = getdate()

	declare @rowcount int
	set @rowcount = 0
	
-- new records
	insert into MP.LoadReleaseDriver 
	(
		UPC,
		CompanyID,
		WorkflowCode,
		ChangeCode,
		ChangeDatetime
	)
	select 
		l.UPC, 
		l.CompanyID, 
		'L',
		'I',
		@timestamp 
	from 
		MP.LoadRelease l
		left outer join MP.Release t 
			on l.UPC = t.UPC and l.CompanyID = t.CompanyID
	where 		
		t.UPC is null and t.CompanyID is null
		
	set @rowcount = @rowcount + @@rowcount

-- Updates
	insert into MP.LoadReleaseDriver 
	(
		UPC,
		CompanyID,
		WorkflowCode,
		ChangeCode,
		ChangeDatetime
	)
	select 
		l.UPC, 
		l.CompanyID, 
		'L',
		'U',
		@timestamp 
	from 
		MP.LoadRelease l
		inner join MP.Release t 
			on l.UPC = t.UPC and l.CompanyID = t.CompanyID
		
	set @rowcount = @rowcount + @@rowcount		
	return @rowcount
	
END
GO