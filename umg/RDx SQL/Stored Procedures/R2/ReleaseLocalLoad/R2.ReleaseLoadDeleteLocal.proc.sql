-- ============================================
-- Description:	Deletes records from R2.ReleaseLocal. Records are only _marked_ as deleted.
-- =============================================
CREATE PROCEDURE R2.ReleaseLoadDeleteLocal
AS
BEGIN
	-- Set CHANGE_CODE to 'UD'(i.e. mark as deleted) duplicate originating records. 
	-- Those records are created when the originating company changes. Only the lates originating record should stay
	update R2.ReleaseLocal
	set
		CHANGE_CODE = 'UD' 
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		R2.ReleaseLocal r
		inner join R2.LoadReleaseLocal l 
			on r.[RELEASE_ID] = l.[RELEASE_ID] and r.[COMPANY_ID] = l.[COMPANY_ID] 
		inner join R2.LoadReleaseLocalDriver ld 
			on l.[RELEASE_ID] = ld.[RELEASE_ID] and l.[COMPANY_ID] = ld.[COMPANY_ID] 
		inner join
		(
			-- finds records with the same release_id and originating_indicator = 'Y'
			select RELEASE_ID, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME)
			from R2.ReleaseLocal
			where (CHANGE_CODE = 'I' OR CHANGE_CODE = 'U')
			group by RELEASE_ID, ORIGINATING_INDICATOR
			having count(RELEASE_ID) > 1 and ORIGINATING_INDICATOR = 'Y' 
		) as t
		on 
			r.RELEASE_ID = t.RELEASE_ID 
		where
			l.[WORKFLOW_CODE] = 'LT'
			and
			ld.[WORKFLOW_CODE] = 'T'
			and 
			(r.CHANGE_DATE_TIME <> t.MAX_CHANGE_DATE_TIME) and (r.ORIGINATING_INDICATOR = 'Y') and (r.CHANGE_CODE = 'I' OR r.CHANGE_CODE = 'U')
			
			
	-- Set CHANGE_CODE to 'UD'(i.e. mark as deleted) duplicate local records. 
	-- Those records are created when the local company changes. Only the latest local record should stay
	update R2.ReleaseLocal
	set
		CHANGE_CODE = 'UD' 
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		R2.ReleaseLocal r
		inner join R2.LoadReleaseLocal l 
			on r.[RELEASE_ID] = l.[RELEASE_ID] and r.[COMPANY_ID] = l.[COMPANY_ID] 
		inner join R2.LoadReleaseLocalDriver ld 
			on l.[RELEASE_ID] = ld.[RELEASE_ID] and l.[COMPANY_ID] = ld.[COMPANY_ID] 
		inner join
		(
			-- finds records with the same RELEASE_COMPANY_LINK_ID
			select RELEASE_COMPANY_LINK_ID, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME)
			from R2.ReleaseLocal
			where (CHANGE_CODE = 'I' OR CHANGE_CODE = 'U')
			group by RELEASE_COMPANY_LINK_ID
			having count(RELEASE_COMPANY_LINK_ID) > 1 
		) as t
		on 
			r.RELEASE_COMPANY_LINK_ID = t.RELEASE_COMPANY_LINK_ID 
		where
			l.[WORKFLOW_CODE] = 'LT'
			and 
			ld.[WORKFLOW_CODE] = 'T'
			and
			(r.CHANGE_DATE_TIME <> t.MAX_CHANGE_DATE_TIME) and (r.CHANGE_CODE = 'I' OR r.CHANGE_CODE = 'U')			
END
