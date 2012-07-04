CREATE TABLE [R2].[LoadTalentName](
	[TALENT_NAME_ID] [numeric](38, 0) NOT NULL,
	[TALENT_ID] [numeric](38, 0) NOT NULL,
	[LAST_NAME] [nvarchar](255) NOT NULL,
	[AUDIT_DATE_CREATED] [datetime] NOT NULL,
	[AUDIT_DATE_CHANGED] [datetime] NOT NULL,
	[AUDIT_EMPLOYEE_NO] [numeric](38, 0) NOT NULL,
	[DQ_STATUS] [nvarchar](6) NOT NULL,
	[TITLE] [nvarchar](255) NULL,
	[FIRST_NAME] [nvarchar](255) NULL,
	[LAST_NAME_PREFIX] [nvarchar](255) NULL,
	[ABBREVIATED_NAME] [nvarchar](255) NULL,
	[SEARCH_INFORMATION] [nvarchar](4000) NULL,
	[PARENT_TALENT_NAME_ID] [numeric](38, 0) NULL,
	[COUNTRY_ID] [nvarchar](2) NULL,
	[DISPLAY_NAME] [nvarchar](255) NULL,
	[FORMATTED_NAME] nvarchar (4000) NULL
) ON [PRIMARY]