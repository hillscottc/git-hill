-- ============================================
-- Description:	Closes a batch in MP.LoadReleaseDriver table.
-- =============================================
CREATE PROCEDURE [MP].[ReleaseLoadBatchClose] 
AS
BEGIN
	update MP.LoadReleaseDriver
		set WorkflowCode = 'C'
	where 
		WorkflowCode = 'T'
END
GO