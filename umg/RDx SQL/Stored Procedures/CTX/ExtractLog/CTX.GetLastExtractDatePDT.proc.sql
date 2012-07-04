CREATE PROCEDURE CTX.GetLastExtractDatePDT(@date datetime output)
AS
	declare @last_delta_time datetime
	declare @last_update_time datetime
	
	-- get last successfull record
	select 
		@last_delta_time = DeltaTimePDT,  
		@last_update_time = StartTime
	from 
		CTX.ExtractLog
	where 
		ID = (select max(ID) from CTX.ExtractLog where [Status] = 'C')
	
	-- CTX is PDT time zone. We are CDT time zone. Convert to PDT before comparing and returning data.
	-- this will not be accurate around daylight savings time
	set @last_update_time = dateadd(hour, -2, @last_update_time)
	
	if (@last_update_time < @last_delta_time)
		set @date = @last_update_time
	else
		set @date = @last_delta_time
;