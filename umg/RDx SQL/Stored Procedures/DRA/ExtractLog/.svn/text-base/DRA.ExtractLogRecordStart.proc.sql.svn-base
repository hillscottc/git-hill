CREATE PROCEDURE DRA.ExtractLogRecordStart
AS
	declare @existingDeltaRows int
	set @existingDeltaRows = 0

	declare @delta_time datetime

	-- see if we have unprocessed records (i.e. rows with workflow_code = 'E')
	select @existingDeltaRows = count(*) from DRA.Delta where WORKFLOW_CODE = 'E'
	if (@existingDeltaRows > 0)	begin
		select @delta_time = max(DeltaTimePDT) from DRA.ExtractLog
	end else begin 
		select @delta_time = delta_time
		from openquery(DRA,
		' 
			select max(date_of_change) delta_time 
			from dra.drv_delta	
		')
	end		

	insert into DRA.ExtractLog ( DeltaTimePDT, StartTime, [Status])
	values ( @delta_time, getdate(),  'P')

	RETURN cast(@@identity as int)
;	
