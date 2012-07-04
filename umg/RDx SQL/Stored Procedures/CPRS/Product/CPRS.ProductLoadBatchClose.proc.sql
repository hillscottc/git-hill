-- =============================================
-- Description:	Closes a batch in CPRS.LoadProductDriver table.
-- =============================================
CREATE PROCEDURE [CPRS].[ProductLoadBatchClose] 
AS
BEGIN
	update CPRS.LoadProductDriver
		set WorkflowCode = 'C'
	where 
		WorkflowCode = 'T'
END
GO