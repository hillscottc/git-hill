CREATE PROCEDURE DRA.ExtractDeltaClear
AS
begin
	declare @existingDeltaRows int
	set @existingDeltaRows = 0

	-- see if we have unprocessed records (i.e. rows with workflow_code = 'E')
	select @existingDeltaRows = count(*) from DRA.Delta where WORKFLOW_CODE = 'E'
	if (@existingDeltaRows > 0)
		return @existingDeltaRows;
		
	truncate table DRA.Delta		
end;	