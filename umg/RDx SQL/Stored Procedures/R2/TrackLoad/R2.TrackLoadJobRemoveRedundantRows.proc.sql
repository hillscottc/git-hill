-- ============================================
-- Description:	Removes duplicate rows from R2.LoadTrack. 
-- =============================================
CREATE PROCEDURE [R2].[TrackLoadJobRemoveRedundantRows] 
AS
BEGIN

	-- Remove records with the same RELEASE_ID, RESOURCE_ID, GROUP_SEQUENCE_NO, SEQUENCE_NO and different change datetime.
	delete R2.LoadTrack
	from 
		R2.LoadTrack r
		inner join
		(
			-- finds duplicate RELEASE_ID, RESOURCE_ID, GROUP_SEQUENCE_NO, SEQUENCE_NO
			select RELEASE_ID, RESOURCE_ID, GROUP_SEQUENCE_NO, SEQUENCE_NO, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME) 
			from R2.LoadTrack 
			where WORKFLOW_CODE = 'LT'
			group by RELEASE_ID, RESOURCE_ID, GROUP_SEQUENCE_NO, SEQUENCE_NO having count(*) > 1
		) as t
		on 
			r.RELEASE_ID = t.RELEASE_ID and r.RESOURCE_ID = t.RESOURCE_ID
			and r.GROUP_SEQUENCE_NO = t.GROUP_SEQUENCE_NO and r.SEQUENCE_NO = t.SEQUENCE_NO
		where
			CHANGE_DATE_TIME <> t.MAX_CHANGE_DATE_TIME
			
	-- Remove records with duplicate release_id, resource_id, GROUP_SEQUENCE_NO, SEQUENCE_NO
	delete R2.LoadTrack
	from 
		R2.LoadTrack r
		inner join
		(
			-- finds duplicate release_id, resource_id, GROUP_SEQUENCE_NO, SEQUENCE_NO
			select RELEASE_ID, RESOURCE_ID, GROUP_SEQUENCE_NO, SEQUENCE_NO,  MAX_ID = max(ID) 
			from R2.LoadTrack 
			where [WORKFLOW_CODE] = 'LT'
			group by RELEASE_ID, RESOURCE_ID, GROUP_SEQUENCE_NO, SEQUENCE_NO having count(*) > 1
		) as t
		on 
			r.RELEASE_ID = t.RELEASE_ID and r.RESOURCE_ID = t.RESOURCE_ID 
			and r.GROUP_SEQUENCE_NO = t.GROUP_SEQUENCE_NO and r.SEQUENCE_NO = t.SEQUENCE_NO
		where
			ID <> t.MAX_ID			
			
END
GO