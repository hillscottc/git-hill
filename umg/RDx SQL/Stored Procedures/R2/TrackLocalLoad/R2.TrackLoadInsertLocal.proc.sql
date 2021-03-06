﻿-- ============================================
-- Description:	Inserts records in R2.TrackLocal
-- =============================================
CREATE PROCEDURE R2.TrackLoadInsertLocal 
AS
BEGIN
	insert into R2.TrackLocal
	select 
		[RELEASE_ID] = l.[RELEASE_ID]
		,[GROUP_SEQUENCE_NO] = l.[GROUP_SEQUENCE_NO]
		,[TRACK_ID] = l.[TRACK_ID]
		,[SEQUENCE_NO] = l.[SEQUENCE_NO]
		,[TRACK_ARTIST_LIST] = l.[TRACK_ARTIST_LIST]
		,[TRACK_TITLE] = l.[TRACK_TITLE]
		,[TRACK_VERSION_TITLE] = l.[TRACK_VERSION_TITLE]
		,[TRACK_TITLE_EXTENSION] = l.[TRACK_TITLE_EXTENSION]
		,[FORMATTED_TRACK_TITLE] = l.[FORMATTED_TRACK_TITLE]
		,[RESOURCE_ID] = l.[RESOURCE_ID]
		,[ACCOUNT_ID] = l.[ACCOUNT_ID]
		,[ISRC] = l.[ISRC]
		,[COUNTRY_ID] = l.[COUNTRY_ID]
		,[FAMILY_ID] = l.[FAMILY_ID]
		,[COMPANY_ID] = l.[COMPANY_ID]
		,[DIVISION_ID] = l.[DIVISION_ID]
		,[LABEL_ID] = l.[LABEL_ID]
		,[ORIGINATING_INDICATOR] = l.[ORIGINATING_INDICATOR]
		
		,CHANGE_CODE = ld.CHANGE_CODE 
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
from 
		R2.LoadTrackLocal l 
		inner join R2.LoadTrackLocalDriver ld 
			on 
				l.RELEASE_ID = ld.RELEASE_ID and l.RESOURCE_ID = ld.RESOURCE_ID 
				and l.GROUP_SEQUENCE_NO = ld.GROUP_SEQUENCE_NO and l.SEQUENCE_NO = ld.SEQUENCE_NO 
				and l.COMPANY_ID = ld.COMPANY_ID
	where 
		(ld.CHANGE_CODE = 'I' or ld.CHANGE_CODE = 'ID') and ld.WORKFLOW_CODE = 'T'
		and
		l.WORKFLOW_CODE = 'LT' 
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.TrackLocal', @@rowcount, 'I'
		
END
