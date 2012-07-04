CREATE TABLE [R2].[LoadTalent](
	[TALENT_ID] [numeric](38, 0) NOT NULL,
	[COMPANY_ID] [nvarchar](6) NOT NULL,
	[TALENT_TYPE] [nvarchar](6) NOT NULL,
	[AUDIT_DATE_CREATED] [datetime] NOT NULL,
	[AUDIT_DATE_CHANGED] [datetime] NOT NULL,
	[AUDIT_EMPLOYEE_NO] [numeric](38, 0) NOT NULL,
	[DQ_STATUS] [nvarchar](6) NOT NULL,
	[COUNTRY_ID] [nvarchar](2) NULL,
	[DATE_OF_BIRTH_YEAR] [nvarchar](4) NULL,
	[DATE_OF_DEATH_YEAR] [nvarchar](4) NULL,
	[RIGHTS_TYPE] [nvarchar](6) NULL,
	[ACCOUNT_ID] [numeric](38, 0) NOT NULL
) ON [PRIMARY]