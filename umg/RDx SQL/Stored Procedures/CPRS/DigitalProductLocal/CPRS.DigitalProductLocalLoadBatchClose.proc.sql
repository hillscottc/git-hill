-- =============================================
-- Description:	Closes a batch in CPRS.LoadDigitalProductLocalDriver table.
-- =============================================
CREATE PROCEDURE [CPRS].[DigitalProductLocalLoadBatchClose] 
AS
BEGIN
	update CPRS.LoadDigitalProductLocalDriver
		set WorkflowCode = 'C'
	where 
		WorkflowCode = 'T'
END
GO