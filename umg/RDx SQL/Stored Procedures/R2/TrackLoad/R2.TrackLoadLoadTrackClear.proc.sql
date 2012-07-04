-- ============================================
-- Description:	Deletes all records from the R2.LoadTrackDriverLocal table
-- =============================================
CREATE PROCEDURE [R2].[TrackLoadLoadTrackClear]
AS
begin
	truncate table R2.LoadTrack;
end	
