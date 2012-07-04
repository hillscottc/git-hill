CREATE TABLE [R2].[Contribution](
	[CONTRIBUTION_ID] [numeric](38, 0) NOT NULL,
	[UNIQUE_ID] [numeric](38, 0) NOT NULL,
	[REPERTOIRE_TYPE] [nvarchar](6) NOT NULL,
	[ROLE_NO] [numeric](38, 0) NOT NULL,
	[TALENT_NAME_ID] [numeric](38, 0) NOT NULL,
	[AUDIT_DATE_CREATED] [datetime] NOT NULL,
	[AUDIT_DATE_CHANGED] [datetime] NOT NULL,
	[AUDIT_EMPLOYEE_NO] [numeric](38, 0) NOT NULL,
	[LABEL_COPY_CREDIT] [nvarchar](max) NULL,
	[SESSION_ID] [numeric](38, 0) NULL,
	[NOTES] [nvarchar](max) NULL,
	[MUSICIAN_CONTRACT_CATEGORY] [nvarchar](6) NULL,
	[SEQUENCE_NO] [numeric](38, 0) NOT NULL,
	[PRIMARY_INDICATOR] [nvarchar](1) NOT NULL,
	[CHANGE_CODE] [varchar](2) DEFAULT 'I' NOT NULL,
	[CHANGE_DATE_TIME] [datetime] DEFAULT GETDATE() NOT NULL,
	[WORKFLOW_CODE] [varchar](2) NOT NULL DEFAULT ('L')
) ON [PRIMARY]
