CREATE PROCEDURE [CPRS].[DigitalProductLoadBatchClose] 
AS
BEGIN
	update CPRS.LoadDigitalProductDriver
		set WorkflowCode = 'C'
	where 
		WorkflowCode = 'T'
END
GO