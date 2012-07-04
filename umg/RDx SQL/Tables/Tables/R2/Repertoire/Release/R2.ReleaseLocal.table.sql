﻿CREATE TABLE [R2].[ReleaseLocal](
	[RELEASE_ID] [numeric](38, 0) NOT NULL,
	[ACCOUNT_ID] [numeric](38, 0) NOT NULL,
	[UPC] [nvarchar](14) NULL,
	[ARTIST_LIST] [nvarchar](max) NULL,
	[RELEASE_LOCAL_ID] [numeric](38, 0) NOT NULL,
	[TITLE] [nvarchar](max) NULL,
	[TITLE_OVERRIDE] [nvarchar](max) NULL,
	[VERSION_TITLE] [nvarchar](max) NULL,
	[VERSION_TITLE_OVERRIDE] [nvarchar](max) NULL,
	[FORMATTED_TITLE] [nvarchar](max) NULL,
	[ARTIST_OVERRIDE] [nvarchar](max) NULL,
	[VERSION_TYPE] [nvarchar](6) NOT NULL,
	[VERSION_TYPE_DESC] [nvarchar](max) NULL,
	[P_NOTICE_YEAR] [nvarchar](4) NULL,
	[P_NOTICE_COMPANY_ID] [numeric](38, 0) NULL,
	[P_NOTICE_COMPANY_NAME] [nvarchar](max) NULL,
	[P_NOTICE_EXTENSION] [nvarchar](max) NULL,
	[FORMATTED_P_NOTICE] [nvarchar](max) NULL,
	[C_NOTICE_YEAR] [nvarchar](4) NULL,
	[C_NOTICE_COMPANY_ID] [numeric](38, 0) NULL,
	[C_NOTICE_COMPANY_NAME] [nvarchar](max) NULL,
	[FORMATTED_C_NOTICE] [nvarchar](max) NULL,
	[SERIES_ID] [numeric](38, 0) NULL,
	[SERIES_TITLE] [nvarchar](max) NULL,
	[VIDEO_NETWORK] [nvarchar](6) NULL,
	[VIDEO_NETWORK_DESC] [nvarchar](max) NULL,
	[VIDEO_SEASON_ID] [nvarchar](max) NULL,
	[VIDEO_ORIGINAL_RELEASE_YEAR] [nvarchar](4) NULL,
	[VIDEO_RATING] [nvarchar](6) NULL,
	[VIDEO_RATING_DESC] [nvarchar](max) NULL,
	[VIDEO_SHORT_DESCRIPTION] [nvarchar](max) NULL,
	[VIDEO_LONG_DESCRIPTION] [nvarchar](max) NULL,
	[E_MARKETING_TAG] [nvarchar](max) NULL,
	[E_RELEASE_LABEL] [nvarchar](max) NULL,
	[NPSC] [nvarchar](8) NULL,
	[VOD_TYPE] [nvarchar](6) NULL,
	[VOD_TYPE_DESC] [nvarchar](max) NULL,
	[RELEASE_COMPANY_LINK_ID] [numeric](38, 0) NOT NULL,
	[COUNTRY_ID] [nvarchar](2) NOT NULL,
	[FAMILY_ID] [nvarchar](6) NULL,
	[COMPANY_ID] [nvarchar](6) NOT NULL,
	[DIVISION_ID] [nvarchar](6) NOT NULL,
	[LABEL_ID] [nvarchar](6) NOT NULL,
	[ORIGINATING_INDICATOR] [nvarchar](1) NOT NULL,
	[STATUS] [nvarchar](1) NOT NULL,
	[STATUS_DESC] [nvarchar](max) NULL,
	[ISSUING_EMPLOYEE_NO] [numeric](38, 0) NULL,
	[ISSUING_EMPLOYEE_NAME] [nvarchar](max) NULL,
	[ROYALTY_ADMIN] [nvarchar](6) NULL,
	[ROYALTY_ADMIN_DESC] [nvarchar](max) NULL,
	[CATALOG_NUMBER] [nvarchar](max) NULL,
	[GENRE] [nvarchar](6) NULL,
	[GENRE_DESC] [nvarchar](max) NULL,
	[RELEASE_DATE_YEAR] [nvarchar](4) NULL,
	[RELEASE_DATE_MONTH] [nvarchar](2) NULL,
	[RELEASE_DATE_DAY] [nvarchar](2) NULL,
	[RELEASE_DATE_DISPLAY] [nvarchar](max) NULL,
	[LOCAL_NOTES] [nvarchar](max) NULL,
	[DQ_STATUS] [nvarchar](6) NOT NULL,
	[DQ_STATUS_DESC] [nvarchar](max) NULL,
	[CHANGE_CODE] [varchar](2) DEFAULT 'I' NOT NULL,
	[CHANGE_DATE_TIME] [datetime] DEFAULT GETDATE() NOT NULL,
	[WORKFLOW_CODE] [varchar](2) NOT NULL DEFAULT ('L')
) ON [PRIMARY]


