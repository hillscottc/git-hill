CREATE TABLE [R2].[LoadProject](
	[PROJECT_ID] [numeric](38, 0) NOT NULL,
	[CODE] [nvarchar](18) NOT NULL,
	[DESCRIPTION] [nvarchar](255) NOT NULL,
	[COMPANY_ID] [nvarchar](6) NOT NULL,
	[DIVISION_ID] [nvarchar](6) NOT NULL,
	[LABEL_ID] [nvarchar](6) NOT NULL,
	[AUDIT_DATE_CREATED] [datetime] NOT NULL,
	[AUDIT_DATE_CHANGED] [datetime] NOT NULL,
	[AUDIT_EMPLOYEE_NO] [numeric](38, 0) NOT NULL,
	[STATUS] [nvarchar](1) NOT NULL,
	[ROYALTY_ADMIN] [nvarchar](6) NULL,
	[BUDGET_NUMBER] [nvarchar](25) NULL,
	[CRA_PROJECT_ID] [nvarchar](30) NULL,
	[ACCOUNT_ID] [numeric](38, 0) NOT NULL
) ON [PRIMARY];