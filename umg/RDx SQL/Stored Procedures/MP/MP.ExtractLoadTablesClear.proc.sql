-- ============================================
-- Description:	Clears MP load tables
-- =============================================
CREATE PROCEDURE MP.ExtractClearLoadTables 
AS
BEGIN
	declare @existingLoadRows int
	set @existingLoadRows = 0

	---- see if we have unprocessed releases (i.e. rows with WorkflowCode = 'E' or WorkflowCode = 'LT')
	select @existingLoadRows = count(*) from MP.LoadRelease where WorkflowCode = 'E' or WorkflowCode = 'LT'
	if (@existingLoadRows > 0)
		return -1;

	---- see if we have unprocessed tracks (i.e. rows with WorkflowCode = 'E' or WorkflowCode = 'LT')
	select @existingLoadRows = count(*) from MP.LoadTrackTerritoryRight where WorkflowCode = 'E' or WorkflowCode = 'LT'
	if (@existingLoadRows > 0)
		return -1;
		
	truncate table MP.LoadRight
	truncate table MP.LoadRelease
	truncate table MP.LoadTrackTerritoryRight		
	
	return 0;
END
GO