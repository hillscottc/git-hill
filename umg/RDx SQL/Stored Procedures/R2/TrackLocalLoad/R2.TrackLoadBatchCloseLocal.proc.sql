-- ============================================
-- Description:	Closes a batch in R2.LoadTrackLocalDriver table.
-- =============================================
CREATE PROCEDURE [R2].[TrackLoadBatchCloseLocal] 
AS
BEGIN
	update R2.LoadTrackLocalDriver
		set [WORKFLOW_CODE] = 'C'
	where 
		[WORKFLOW_CODE] = 'T'
END
GO