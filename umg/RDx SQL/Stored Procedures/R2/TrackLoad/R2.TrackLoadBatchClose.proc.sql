-- ============================================
-- Description:	Closes a batch in R2.LoadTrackDriver table.
-- =============================================
CREATE PROCEDURE [R2].[TrackLoadBatchClose] 
AS
BEGIN
	update R2.LoadTrackDriver
		set [WORKFLOW_CODE] = 'C'
	where 
		[WORKFLOW_CODE] = 'T'
END
GO