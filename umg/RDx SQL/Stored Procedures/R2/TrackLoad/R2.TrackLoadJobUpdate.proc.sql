-- ============================================
-- Description:	Reserves all extracted records (E) in R2.LoadTrack for Loading / Transformation (LT).
-- =============================================
CREATE PROCEDURE [R2].[TrackLoadJobUpdate] 
AS
BEGIN
	UPDATE R2.LoadTrack
	SET WORKFLOW_CODE = 'C' 
	from R2.LoadTrack l 
		inner join R2.LoadTrackDriver ld 
			on 
				l.RELEASE_ID = ld.RELEASE_ID and l.RESOURCE_ID = ld.RESOURCE_ID
				and l.GROUP_SEQUENCE_NO = ld.GROUP_SEQUENCE_NO and l.SEQUENCE_NO = ld.SEQUENCE_NO 
	where 
		l.WORKFLOW_CODE = 'LT'
		and
		ld.[WORKFLOW_CODE] = 'T'
END
GO