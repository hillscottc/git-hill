CREATE TABLE [R2].[Country](
	[COUNTRY_ID] [nvarchar](2) NOT NULL,
	[NAME] [nvarchar](255) NOT NULL,
	[AUDIT_DATE_CHANGED] [datetime] NOT NULL,
	[AUDIT_DATE_CREATED] [datetime] NOT NULL,
	[AUDIT_EMPLOYEE_NO] [numeric](38, 0) NOT NULL,
	[STATUS] [nvarchar](1) NOT NULL,
	[DATE_LAST_GT] [datetime] NULL,
	[GT_COUNTRY_ID] [numeric](3, 0) NULL,
	[GT_COUNTRY_CODE] [nvarchar](3) NULL,
	[UNIQUE_ID] [numeric](38, 0) NOT NULL,
	[CHANGE_CODE] [varchar](2) DEFAULT 'I' NOT NULL,
	[CHANGE_DATE_TIME] [datetime] DEFAULT GETDATE() NOT NULL,
	[WORKFLOW_CODE] [varchar](2) NOT NULL DEFAULT ('L')
) ON [PRIMARY]