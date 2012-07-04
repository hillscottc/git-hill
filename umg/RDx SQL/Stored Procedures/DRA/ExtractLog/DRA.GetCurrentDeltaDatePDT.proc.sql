CREATE PROCEDURE DRA.GetCurrentDeltaDatePDT(@date datetime output)
AS
	select @date = delta_time
	from openquery(DRA,
	'
		select max(date_of_change) delta_time 
		from dra.drv_delta	
	')	
;