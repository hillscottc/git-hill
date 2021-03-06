﻿-- ============================================
-- Description:	Deletes records from R2.TrackLocal. Records are only _marked_ as deleted.
-- =============================================
CREATE PROCEDURE R2.TrackLoadDeleteLocal
AS
BEGIN
	-- Set CHANGE_CODE to 'UD'(i.e. mark as deleted) duplicate originating records. 
	-- Those records are created when the originating company changes. Only the latest originating record should stay
	update R2.TrackLocal
	set
		CHANGE_CODE = 'UD' 
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		R2.TrackLocal r
		inner join R2.LoadTrackLocal l 
			on 
				r.RELEASE_ID = l.RELEASE_ID and r.RESOURCE_ID = l.RESOURCE_ID 
				and r.GROUP_SEQUENCE_NO = l.GROUP_SEQUENCE_NO and r.SEQUENCE_NO = l.SEQUENCE_NO 
				and r.COMPANY_ID = l.COMPANY_ID
		inner join R2.LoadTrackLocalDriver ld 
			on 
				l.RELEASE_ID = ld.RELEASE_ID and l.RESOURCE_ID = ld.RESOURCE_ID 
				and l.GROUP_SEQUENCE_NO = ld.GROUP_SEQUENCE_NO and l.SEQUENCE_NO = ld.SEQUENCE_NO 
				and l.COMPANY_ID = ld.COMPANY_ID 
		inner join
		(
			-- finds records with the same track_id and originating_indicator = 'Y'
			select TRACK_ID, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME)
			from R2.TrackLocal
			where (CHANGE_CODE = 'I' OR CHANGE_CODE = 'U')
			group by TRACK_ID, ORIGINATING_INDICATOR
			having count(TRACK_ID) > 1 and ORIGINATING_INDICATOR = 'Y' 
		) as t
		on 
			r.TRACK_ID = t.TRACK_ID 
	where
		l.WORKFLOW_CODE = 'LT'
		and 
		ld.WORKFLOW_CODE = 'T'
		and
		(r.CHANGE_DATE_TIME <> t.MAX_CHANGE_DATE_TIME) and (r.ORIGINATING_INDICATOR = 'Y') and (r.CHANGE_CODE = 'I' OR r.CHANGE_CODE = 'U')
END
