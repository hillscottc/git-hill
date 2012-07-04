-- =============================================
-- Description:	Clears CPRS load tables
-- =============================================
CREATE PROCEDURE [CPRS].[ExtractClearLoadTables] 
AS
BEGIN
	declare @existingJobRows int
	set @existingJobRows = 0

	-- see if we have unprocessed records (i.e. rows with workflow_code = 'E')
	select @existingJobRows = count(*) from CPRS.ExtractDriver where WorkflowCode = 'E'
	if (@existingJobRows > 0)
		return;
		
	truncate table [CPRS].[LoadProduct]		
	truncate table [CPRS].[LoadDigitalProduct]
	truncate table [CPRS].[LoadDigitalProductLocal]
	truncate table [CPRS].[LoadPhysicalProduct]
	truncate table [CPRS].[LoadPhysicalProductLocal]
	truncate table [CPRS].[LoadProductTerritoryRight]
END
GO