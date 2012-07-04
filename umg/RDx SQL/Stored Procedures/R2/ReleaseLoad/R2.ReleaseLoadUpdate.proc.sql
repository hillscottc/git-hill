﻿-- ============================================
-- Description:	Updates records in R2.Release
-- =============================================
CREATE PROCEDURE R2.ReleaseLoadUpdate
AS
BEGIN
	update R2.Release
	set
		[RELEASE_ID] = l.[RELEASE_ID]
		,[ACCOUNT_ID] = l.[ACCOUNT_ID]
		,[UPC] = l.[UPC]
		,[CONTEXT_UPC] = l.[CONTEXT_UPC] 
		,[UPC_TYPE] = l.[UPC_TYPE]
		,[UPC_AUTO_DATE] = l.[UPC_AUTO_DATE]
		,[GRID] = l.[GRID]
		,[CONTEXT_RELEASE_ID] = l.[CONTEXT_RELEASE_ID]
		,[CONTEXT_TYPE] = l.[CONTEXT_TYPE]
		,[TOTAL_TRACKS] = l.[TOTAL_TRACKS]
		,[TOTAL_TIME] = l.[TOTAL_TIME]
		,[FORMATTED_TOTAL_TIME] = l.[FORMATTED_TOTAL_TIME]
		,[ORIGINAL_PROJECT_ID] = l.[ORIGINAL_PROJECT_ID]
		,[CONFIG_ID] = l.[CONFIG_ID]
		,[CONFIG_DESC] = l.[CONFIG_DESC]
		,[CONFIG_SCOPE] = l.[CONFIG_SCOPE]
		,[UNIQUE_INDICATOR] = l.[UNIQUE_INDICATOR]
		,[PACKAGE_INDICATOR] = l.[PACKAGE_INDICATOR]
		,[SOUNDTRACK_INDICATOR] = l.[SOUNDTRACK_INDICATOR]
		,[MUSIC_TYPE] = l.[MUSIC_TYPE]
		,[MUSIC_TYPE_DESC] = l.[MUSIC_TYPE_DESC]
		,[RELEASE_TYPE_DESC] = l.[RELEASE_TYPE_DESC]
		,[P_NOTICE_COMPILATION_DESC] = l.[P_NOTICE_COMPILATION_DESC]
		,[PACKAGING_DEFINITION] = l.[PACKAGING_DEFINITION]
		,[VIDEO_TYPE] = l.[VIDEO_TYPE]
		,[VIDEO_TYPE_DESC] = l.[VIDEO_TYPE_DESC]
		,[NOTES] = l.[NOTES]
		,[MISCELLANEOUS_CREDITS] = l.[MISCELLANEOUS_CREDITS]
		,[CRA_PROJECT_ID] = l.[CRA_PROJECT_ID]
		,[SEARCH_INFORMATION] = l.[SEARCH_INFORMATION]
		,[DIGITAL_FORMAT] = l.[DIGITAL_FORMAT]
		,[DIGITAL_FORMAT_DESC] = l.[DIGITAL_FORMAT_DESC]
		,[THEMATIC_CATEGORY] = l.[THEMATIC_CATEGORY]
		,[THEMATIC_CATEGORY_DESC] = l.[THEMATIC_CATEGORY_DESC]
		,[CLASSICAL_CATEGORY] = l.[CLASSICAL_CATEGORY]
		,[CLASSICAL_CATEGORY_DESC] = l.[CLASSICAL_CATEGORY_DESC]
		,[CLASSICAL_SUBCATEGORY] = l.[CLASSICAL_SUBCATEGORY]
		,[CLASSICAL_SUBCATEGORY_DESC] = l.[CLASSICAL_SUBCATEGORY_DESC]
		,[AVAILABILITY_OVERRIDE_REASON] = l.[AVAILABILITY_OVERRIDE_REASON]
		,[ORIGINATING_COUNTRY_ID] = l.[ORIGINATING_COUNTRY_ID]
		,[ORIGINATING_FAMILY_ID] = l.[ORIGINATING_FAMILY_ID]
		,[ORIGINATING_COMPANY_ID] = l.[ORIGINATING_COMPANY_ID]
		,[ORIGINATING_DIVISION_ID] = l.[ORIGINATING_DIVISION_ID]
		,[ORIGINATING_LABEL_ID] = l.[ORIGINATING_LABEL_ID]
		
		,CHANGE_CODE = ld.CHANGE_CODE
		,CHANGE_DATE_TIME = getdate()
		,WORKFLOW_CODE = 'L'
	from 
		R2.Release t
		inner join R2.LoadRelease l 
			on t.[RELEASE_ID] = l.[RELEASE_ID] 
		inner join R2.LoadReleaseDriver ld 
			on l.[RELEASE_ID] = ld.[RELEASE_ID]
	where
		(ld.CHANGE_CODE = 'U' or ld.CHANGE_CODE = 'UD') and ld.[WORKFLOW_CODE] = 'T'
		and 
		l.[WORKFLOW_CODE] = 'LT'
		
	-- update row counts		
	exec R2.TransformLogTaskInsert 'R2.Release', @@rowcount, 'U'
		
END
