CREATE PROCEDURE DRA.ExtractDeltaLoad(@startTime datetime)
AS
begin
	declare @existingDeltaRows int
	set @existingDeltaRows = 0

	-- see if we have unprocessed records (i.e. rows with workflow_code = 'E')
	select @existingDeltaRows = count(*) from DRA.Delta where WORKFLOW_CODE = 'E'
	if (@existingDeltaRows > 0)
		return @existingDeltaRows;

	-- style 120 => yyyy-mm-dd hh:mi:ss(24h)
	declare @startTimeString nvarchar(30)
	set @startTimeString = convert(nvarchar(30), @startTime, 120)

	declare @rowcount int
	set @rowcount = 0

	-- import delta records
	insert into DRA.Delta
	(
		RELEASE_ID, 
		RESOURCE_ID, 
		ENTITY_CLEARANCE_SET_ID, 
		AUDIT_ACTION, 
		DATE_OF_CHANGE
	)
	execute 
	('
		SELECT 
			D.RELEASE_ID, 
			D.RESOURCE_ID, 
			D.ENTITY_CLEARANCE_SET_ID, 
			D.AUDIT_ACTION, 
			D.DATE_OF_CHANGE
		FROM 
		    DRA.DRV_DELTA D
		WHERE
			D.DATE_OF_CHANGE > to_date (''' + @startTimeString + ''', ''yyyy-mm-dd hh24:mi:ss'')
	') at DRA

	set @rowcount = @rowcount + @@rowcount

	return @rowcount
end;	