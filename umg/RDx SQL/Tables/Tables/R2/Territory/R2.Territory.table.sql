CREATE TABLE [R2].[Territory](
	[TERRITORY_ID] [numeric](3, 0) NOT NULL,
	[NAME] [nvarchar](40) NOT NULL,
	[AUDIT_DATE_CREATED] [datetime] NOT NULL,
	[AUDIT_DATE_CHANGED] [datetime] NOT NULL,
	[AUDIT_EMPLOYEE_NO] [numeric](38, 0) NOT NULL,
	[STATUS] [nvarchar](1) NOT NULL,
	[SYNONYM_NAME] [nvarchar](40) NULL,
	[OFFICIAL_NAME] [nvarchar](40) NULL,
	[FORMER_NAME] [nvarchar](40) NULL,
	[ALPHA_3_CODE] [nvarchar](3) NULL,
	[COMMENTS] [nvarchar](120) NULL,
	[DATE_LAST_GT] [datetime] NULL,
	[CHANGE_CODE] [varchar](2) DEFAULT 'I' NOT NULL,
	[CHANGE_DATE_TIME] [datetime] DEFAULT GETDATE() NOT NULL,
	[WORKFLOW_CODE] [varchar](2) NOT NULL DEFAULT ('L')
) ON [PRIMARY]
