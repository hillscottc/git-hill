﻿-- ============================================
-- Description:	Removes duplicate rows from R2.LoadTrackLocal. 
-- =============================================
CREATE PROCEDURE [R2].[TrackLoadJobRemoveRedundantRowsLocal] 
AS
BEGIN
	-- This cleans multiple records for the same "company_id, release_id, resource_id", and keeps only the last record
	delete R2.LoadTrackLocal
	from 
		R2.LoadTrackLocal r
		inner join
		(
			-- finds duplicate company_id, release_id, resource_id
			select COMPANY_ID, RELEASE_ID, RESOURCE_ID, GROUP_SEQUENCE_NO, SEQUENCE_NO, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME) 
			from R2.LoadTrackLocal 
			where [WORKFLOW_CODE] = 'LT'
			group by COMPANY_ID, RELEASE_ID, RESOURCE_ID, GROUP_SEQUENCE_NO, SEQUENCE_NO having count(*) > 1
		) as t
		on 
			r.COMPANY_ID = t.COMPANY_ID and r.RELEASE_ID = t.RELEASE_ID 
			and r.GROUP_SEQUENCE_NO = t.GROUP_SEQUENCE_NO and r.SEQUENCE_NO = t.SEQUENCE_NO
			and r.RESOURCE_ID = t.RESOURCE_ID 
		where
			CHANGE_DATE_TIME < t.MAX_CHANGE_DATE_TIME
			
	-- Clean records with duplicate "company_id, release_id, resource_id, change_date_time"
	delete R2.LoadTrackLocal
	from 
		R2.LoadTrackLocal r
		inner join
		(
			-- finds duplicate company_id, release_id, resource_id
			select COMPANY_ID, RELEASE_ID, RESOURCE_ID, GROUP_SEQUENCE_NO, SEQUENCE_NO, MAX_ID = max(ID) 
			from R2.LoadTrackLocal 
			where [WORKFLOW_CODE] = 'LT'
			group by COMPANY_ID, RELEASE_ID, RESOURCE_ID, GROUP_SEQUENCE_NO, SEQUENCE_NO having count(*) > 1
		) as t
		on 
			r.COMPANY_ID = t.COMPANY_ID and r.RELEASE_ID = t.RELEASE_ID 
			and r.GROUP_SEQUENCE_NO = t.GROUP_SEQUENCE_NO and r.SEQUENCE_NO = t.SEQUENCE_NO
			and r.RESOURCE_ID = t.RESOURCE_ID 
		where
			ID <> t.MAX_ID						
			
END
GO