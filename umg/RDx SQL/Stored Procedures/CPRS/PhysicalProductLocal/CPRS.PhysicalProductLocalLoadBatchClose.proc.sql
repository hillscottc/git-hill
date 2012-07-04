-- =============================================
-- Description:	Closes a batch in CPRS.LoadPhysicalProductLocalDriver table.
-- =============================================
CREATE PROCEDURE [CPRS].[PhysicalProductLocalLoadBatchClose] 
AS
BEGIN
	update CPRS.LoadPhysicalProductLocalDriver
		set WorkflowCode = 'C'
	where 
		WorkflowCode = 'T'
END
GO