CREATE TABLE [R2].[Role](
	[ROLE_NO] [numeric](38, 0) NOT NULL,
	[NAME] [nvarchar](50) NOT NULL,
	[AUDIT_DATE_CHANGED] [datetime] NOT NULL,
	[AUDIT_DATE_CREATED] [datetime] NOT NULL,
	[AUDIT_EMPLOYEE_NO] [numeric](38, 0) NOT NULL,
	[ROLE_GROUP] [nvarchar](6) NULL,
	[CREDIT_PREFIX] [nvarchar](50) NULL,
	[CHANGE_CODE] [varchar](2) DEFAULT 'I' NOT NULL,
	[CHANGE_DATE_TIME] [datetime] DEFAULT GETDATE() NOT NULL,
	[WORKFLOW_CODE] [varchar](2) NOT NULL DEFAULT ('L')
) ON [PRIMARY]
