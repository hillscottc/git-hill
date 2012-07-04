-- ============================================
-- Description:	Clears DRA clearance set tables
-- =============================================
CREATE PROCEDURE [DRA].[ExtractLoadEntityClearanceSetTablesClear] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have unprocessed records (i.e. rows with workflow_code = 'E')
	select @existingJobRows = count(*) from DRA.ExtractDriverEntityClearanceSet where WORKFLOW_CODE = 'E'
	if (@existingJobRows > 0)
		return;
		
	truncate table [DRA].[LoadEntityClearance]		
	truncate table [DRA].[LoadEntityClearanceSet]		
	truncate table [DRA].[LoadEntityCountryRight]
	truncate table [DRA].[LoadEntityCountryRightMV]
	truncate table [DRA].[LoadEntityRightsPeriod]
	truncate table [DRA].[LoadEntityTerritoryRight]
	
END
GO