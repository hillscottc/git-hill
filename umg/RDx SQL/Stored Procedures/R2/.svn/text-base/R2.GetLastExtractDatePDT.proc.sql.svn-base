CREATE PROCEDURE R2.GetLastExtractDatePDT(@date datetime output)
AS
	declare @last_snapshot_time datetime
	declare @last_update_time datetime
	
	-- get last successfull record
	select 
		@last_snapshot_time = SnapshotTimePDT,  
		@last_update_time = StartTime
	from 
		R2.ExtractLog
	where 
		ID = (select max(ID) from R2.ExtractLog where [Status] = 'C')
	
	-- R2 is PDT time zone. We are CDT time zone. Convert to PDT before comparing and returning data.
	-- this will not be accurate around daylight savings time
	set @last_update_time = dateadd(hour, -2, @last_update_time)
	
	if (@last_update_time < @last_snapshot_time)
		set @date = @last_update_time
	else
		set @date = @last_snapshot_time
;