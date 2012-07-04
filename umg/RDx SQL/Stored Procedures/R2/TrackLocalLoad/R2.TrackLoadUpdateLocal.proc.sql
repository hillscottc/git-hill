-- ============================================
-- Description:	Updates records in R2.Track
-- =============================================
CREATE PROCEDURE R2.TrackLoadUpdateLocal
AS
BEGIN
	update R2.TrackLocal
	set
		[RELEASE_ID] = l.[RELEASE_ID]
		,[TRACK_ID] = l.[TRACK_ID]
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
		R2.TrackLocal t
		inner join R2.LoadTrackLocal l 
			on 
				t.RELEASE_ID = l.RELEASE_ID and t.RESOURCE_ID = l.RESOURCE_ID
				and t.GROUP_SEQUENCE_NO = l.GROUP_SEQUENCE_NO and t.SEQUENCE_NO = l.SEQUENCE_NO 
				and t.COMPANY_ID = l.COMPANY_ID
		inner join R2.LoadTrackLocalDriver ld 
			on 
				l.RELEASE_ID = ld.RELEASE_ID and l.RESOURCE_ID = ld.RESOURCE_ID 
				and l.GROUP_SEQUENCE_NO = ld.GROUP_SEQUENCE_NO and l.SEQUENCE_NO = ld.SEQUENCE_NO
				and l.COMPANY_ID = ld.COMPANY_ID 
	where
		(ld.CHANGE_CODE = 'U' or ld.CHANGE_CODE = 'UD') and ld.WORKFLOW_CODE = 'T'
		and 
		l.WORKFLOW_CODE = 'LT'
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.TrackLocal', @@rowcount, 'U'
		
END
