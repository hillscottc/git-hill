﻿CREATE TABLE [R2].[LoadResource](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[RESOURCE_ID] [numeric](38, 0) NOT NULL,
	[ACCOUNT_ID] [numeric](38, 0) NOT NULL,
	[ISRC] [nvarchar](12) NULL,
	[RESOURCE_TYPE] [nvarchar](6) NOT NULL,
	[RESOURCE_TYPE_DESC] [nvarchar](max) NULL,
	[ORIGINAL_PROJECT_ID] [numeric](38, 0) NOT NULL,
	[TIME] [numeric](38, 0) NOT NULL,
	[FORMATTED_TIME] [nvarchar](max) NULL,
	[MUSIC_TYPE] [nvarchar](6) NULL,
	[MUSIC_TYPE_DESC] [nvarchar](max) NULL,
	[LANGUAGE_NO] [numeric](38, 0) NULL,
	[LANGUAGE_DESC] [nvarchar](max) NULL,
	[MISCELLANEOUS_CREDITS] [nvarchar](max) NULL,
	[SAMPLE_CREDITS] [nvarchar](max) NULL,
	[TECHNICAL_FORMAT] [nvarchar](6) NULL,
	[TECHNICAL_FORMAT_DESC] [nvarchar](max) NULL,
	[ANALOG_DIGITAL_CODE] [nvarchar](6) NULL,
	[ANALOG_DIGITAL_CODE_DESC] [nvarchar](max) NULL,
	[SAMPLING_FREQUENCY] [nvarchar](6) NULL,
	[SAMPLING_FREQUENCY_DESC] [nvarchar](max) NULL,
	[BIT_DEPTH] [nvarchar](6) NULL,
	[BIT_DEPTH_DESC] [nvarchar](max) NULL,
	[SCORE_PUBLISHER_ID] [numeric](38, 0) NULL,
	[SCORE_PUBLISHER_DESC] [nvarchar](max) NULL,
	[SEARCH_INFORMATION] [nvarchar](max) NULL,
	[SESSION_NAME] [nvarchar](max) NULL,
	[SESSION_COUNTRY_ID] [nvarchar](2) NULL,
	[SESSION_LOCATION_ID] [numeric](38, 0) NULL,
	[SESSION_LOCATION_DESC] [nvarchar](max) NULL,
	[SESSION_SETTING] [nvarchar](6) NULL,
	[SESSION_SETTING_DESC] [nvarchar](max) NULL,
	[SESSION_UNION_TYPE] [nvarchar](6) NULL,
	[SESSION_UNION_TYPE_DESC] [nvarchar](max) NULL,
	[SESSION_PERFORMANCE_TYPE] [nvarchar](6) NULL,
	[SESSION_PERFORMANCE_TYPE_DESC] [nvarchar](max) NULL,
	[SESSION_START_DATE_YEAR] [nvarchar](4) NULL,
	[SESSION_START_DATE_MONTH] [nvarchar](2) NULL,
	[SESSION_START_DATE_DAY] [nvarchar](2) NULL,
	[SESSION_START_DATE] [nvarchar](max) NULL,
	[SESSION_END_DATE_YEAR] [nvarchar](4) NULL,
	[SESSION_END_DATE_MONTH] [nvarchar](2) NULL,
	[SESSION_END_DATE_DAY] [nvarchar](2) NULL,
	[SESSION_END_DATE] [nvarchar](max) NULL,
	[ORIGINAL_MATRIX_NUMBER] [nvarchar](max) NULL,
	[MASTERING_TRACK_COUNT] [numeric](38, 0) NULL,
	[CATEGORY] [nvarchar](6) NULL,
	[CATEGORY_DESC] [nvarchar](max) NULL,
	[FORMAT] [nvarchar](6) NULL,
	[FORMAT_DESC] [nvarchar](max) NULL,
	[COLOR_MODE] [nvarchar](6) NULL,
	[COLOR_MODE_DESC] [nvarchar](max) NULL,
	[RESOLUTION] [nvarchar](6) NULL,
	[RESOLUTION_DESC] [nvarchar](max) NULL,
	[MEASUREMENT] [nvarchar](6) NULL,
	[MEASUREMENT_DESC] [nvarchar](max) NULL,
	[HEIGHT] [numeric](38, 0) NULL,
	[WIDTH] [numeric](38, 0) NULL,
	[VIDEO_TYPE] [nvarchar](6) NULL,
	[VIDEO_TYPE_DESC] [nvarchar](max) NULL,
	[VIDEO_PRODUCTION_NUMBER] [nvarchar](max) NULL,
	[NOTES] [nvarchar](max) NULL,
	[ISAN] [nvarchar](max) NULL,
	[AVAILABLE_INDICATOR] [nvarchar](1) NOT NULL,
	[ORIGINATING_COUNTRY_ID] [nvarchar](2) NOT NULL,
	[ORIGINATING_FAMILY_ID] [nvarchar](6) NULL,
	[ORIGINATING_COMPANY_ID] [nvarchar](6) NOT NULL,
	[ORIGINATING_DIVISION_ID] [nvarchar](6) NOT NULL,
	[ORIGINATING_LABEL_ID] [nvarchar](6) NOT NULL,
	[CHANGE_CODE] [varchar](2) DEFAULT 'I' NOT NULL,
	[CHANGE_DATE_TIME] [datetime] DEFAULT GETDATE() NOT NULL,	
	[WORKFLOW_CODE] [varchar](2) DEFAULT 'E' NOT NULL
) ON [PRIMARY]
