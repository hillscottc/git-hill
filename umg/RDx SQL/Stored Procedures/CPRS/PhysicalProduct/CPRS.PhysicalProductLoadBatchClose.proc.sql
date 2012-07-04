-- =============================================
-- Description:	Closes a batch in CPRS.LoadPhysicalProductDriver table.
-- =============================================
CREATE PROCEDURE [CPRS].[PhysicalProductLoadBatchClose] 
AS
BEGIN
	update CPRS.LoadPhysicalProductDriver
		set WorkflowCode = 'C'
	where 
		WorkflowCode = 'T'
END
GO