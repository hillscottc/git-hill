-- ============================================
-- Description:	Closes a batch in MP.LoadTrackTerritoryRightDriver table.
-- =============================================
CREATE PROCEDURE [MP].[TrackTerritoryRightLoadBatchClose] 
AS
BEGIN
	update MP.LoadTrackTerritoryRightDriver
		set WorkflowCode = 'C'
	where 
		WorkflowCode = 'T'
END
GO