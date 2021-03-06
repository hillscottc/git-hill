﻿-- ============================================
-- Description:	Deletes records from R2.ResourceLocal. Records are only _marked_ as deleted.
-- =============================================
CREATE PROCEDURE R2.ResourceLoadDeleteLocal
AS
BEGIN
	-- Set CHANGE_CODE to 'UD'(i.e. mark as deleted) duplicate originating records. 
	-- Those records are created when the originating company changes. Only the lates originating record should stay
	update R2.ResourceLocal
	set
		CHANGE_CODE = 'UD' 
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		R2.ResourceLocal r
		inner join R2.LoadResourceLocal l 
			on r.[RESOURCE_ID] = l.[RESOURCE_ID] and r.[COMPANY_ID] = l.[COMPANY_ID] 
		inner join R2.LoadResourceLocalDriver ld 
			on l.[RESOURCE_ID] = ld.[RESOURCE_ID] and l.[COMPANY_ID] = ld.[COMPANY_ID] 
		inner join
		(
			-- finds records with the same RESOURCE_ID and ORIGINATING_INDICATOR = 'Y'
			select RESOURCE_ID, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME)
			from R2.ResourceLocal
			where (CHANGE_CODE = 'I' OR CHANGE_CODE = 'U')
			group by RESOURCE_ID, ORIGINATING_INDICATOR
			having count(RESOURCE_ID) > 1 and ORIGINATING_INDICATOR = 'Y' 
		) as t
		on 
			r.RESOURCE_ID = t.RESOURCE_ID 
		where
			l.[WORKFLOW_CODE] = 'LT'
			and 
			ld.[WORKFLOW_CODE] = 'T'
			and
			(r.CHANGE_DATE_TIME <> t.MAX_CHANGE_DATE_TIME) and (r.ORIGINATING_INDICATOR = 'Y') and (r.CHANGE_CODE = 'I' OR r.CHANGE_CODE = 'U')
			
			
	-- Set CHANGE_CODE to 'UD'(i.e. mark as deleted) duplicate local records. 
	-- Those records are created when the local company changes. Only the latest local record should stay
	update R2.ResourceLocal
	set
		CHANGE_CODE = 'UD' 
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		R2.ResourceLocal r
		inner join R2.LoadResourceLocal l 
			on r.[RESOURCE_ID] = l.[RESOURCE_ID] and r.[COMPANY_ID] = l.[COMPANY_ID] 
		inner join R2.LoadResourceLocalDriver ld 
			on l.[RESOURCE_ID] = ld.[RESOURCE_ID] and l.[COMPANY_ID] = ld.[COMPANY_ID] 
		inner join
		(
			-- finds records with the same RESOURCE_COMPANY_LINK_ID
			select RESOURCE_COMPANY_LINK_ID, MAX_CHANGE_DATE_TIME = max(CHANGE_DATE_TIME)
			from R2.ResourceLocal
			where (CHANGE_CODE = 'I' OR CHANGE_CODE = 'U')
			group by RESOURCE_COMPANY_LINK_ID
			having count(RESOURCE_COMPANY_LINK_ID) > 1 
		) as t
		on 
			r.RESOURCE_COMPANY_LINK_ID = t.RESOURCE_COMPANY_LINK_ID 
		where
			l.[WORKFLOW_CODE] = 'LT'
			and 
			ld.[WORKFLOW_CODE] = 'T'
			and
			(r.CHANGE_DATE_TIME <> t.MAX_CHANGE_DATE_TIME) and (r.CHANGE_CODE = 'I' OR r.CHANGE_CODE = 'U')
END
