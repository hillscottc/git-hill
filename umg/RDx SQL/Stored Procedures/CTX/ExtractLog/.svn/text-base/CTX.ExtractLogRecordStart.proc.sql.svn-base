CREATE PROCEDURE CTX.ExtractLogRecordStart
AS
	declare @existingDeltaRows int
	set @existingDeltaRows = 0

	-- see if we have unprocessed records (i.e. rows with workflow_code = 'E')
	select @existingDeltaRows = count(*) from CTX.Delta where WORKFLOW_CODE = 'E'
	if (@existingDeltaRows > 0)
		return 0;

	declare @delta_time datetime
	select @delta_time = delta_time
	from openquery(CTX,
	' 
		select max(date_of_change) delta_time 
		from contraxx.ctv_delta
	')

	insert into CTX.ExtractLog ( DeltaTimePDT, StartTime, [Status])
	values ( @delta_time, getdate(),  'P')

	RETURN cast(@@identity as int)
;	
