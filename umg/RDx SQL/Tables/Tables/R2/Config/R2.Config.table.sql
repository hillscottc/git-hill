CREATE TABLE [R2].[Config]
(
	[CONFIG_ID] [nvarchar](6) NOT NULL,
	[CONFIG_GROUP] [nvarchar](5) NOT NULL,
	[NAME] [nvarchar](60) NOT NULL,
	[AUDIT_DATE_CREATED] [datetime] NOT NULL,
	[AUDIT_DATE_CHANGED] [datetime] NOT NULL,
	[AUDIT_EMPLOYEE_NO] [numeric](38, 0) NOT NULL,
	[STATUS] [nvarchar](1) NOT NULL,
	[NUMBER_OF_SIDES] [numeric](1, 0) NOT NULL,
	[PROGRAM_DESC_1] [nvarchar](10) NULL,
	[DATE_LAST_GT] [datetime] NOT NULL,
	[RELEASE_GROUPING] [nvarchar](1) NULL,
	[ISAC_CONFIG_CODE] [nvarchar](8) NOT NULL,
	[UNIQUE_ID] [numeric](38, 0) NOT NULL,
	[DIGITAL_EQUIV_CONFIG_ID] [nvarchar](6) NULL,
	[CONFIG_TYPE] [nvarchar](1) NOT NULL,
	[CHANGE_CODE] [varchar](2) DEFAULT 'I' NOT NULL,
	[CHANGE_DATE_TIME] [datetime] DEFAULT GETDATE() NOT NULL,
	[WORKFLOW_CODE] [varchar](2) NOT NULL DEFAULT ('L')
) ON [PRIMARY]