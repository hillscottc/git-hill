CREATE PROCEDURE CTX.ExtractDeltaLoad(@startTime datetime)
AS
begin
	declare @existingDeltaRows int
	set @existingDeltaRows = 0

	-- see if we have unprocessed records (i.e. rows with workflow_code = 'E')
	select @existingDeltaRows = count(*) from CTX.Delta where WORKFLOW_CODE = 'E'
	if (@existingDeltaRows > 0)
		return @existingDeltaRows;

	-- style 120 => yyyy-mm-dd hh:mi:ss(24h)
	declare @startTimeString nvarchar(30)
	set @startTimeString = convert(nvarchar(30), @startTime, 120)

	-- import delta records
	insert into CTX.Delta
	(
		CONTAINER_ID, 
		CHANGE_TYPE, 
		DATE_OF_CHANGE
	)
	execute 
	('
		SELECT 
			C.CONTAINER_ID, 
			C.CHANGE_TYPE, 
			C.DATE_OF_CHANGE 
		FROM 
			CONTRAXX.CTV_DELTA C
		WHERE
			C.PROCESS_CODE = ''CTX''
			and
			C.DATE_OF_CHANGE > to_date (''' + @startTimeString + ''', ''yyyy-mm-dd hh24:mi:ss'')
	') at CTX

	return @@rowcount
end;	