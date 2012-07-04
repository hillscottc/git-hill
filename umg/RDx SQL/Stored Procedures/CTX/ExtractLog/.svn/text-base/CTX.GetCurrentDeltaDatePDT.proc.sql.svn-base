CREATE PROCEDURE CTX.GetCurrentDeltaDatePDT(@date datetime output)
AS
	select @date = delta_time
	from openquery(CTX,
	'
		select max(date_of_change) delta_time 
		from contraxx.ctv_delta
	')	
;