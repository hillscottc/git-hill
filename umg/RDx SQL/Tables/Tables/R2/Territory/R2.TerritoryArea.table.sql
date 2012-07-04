﻿CREATE TABLE [R2].[TerritoryArea](
	[TERRITORY_AREA] [numeric](3, 0) NOT NULL,
	[TERRITORY_MEMBER] [numeric](3, 0) NOT NULL,
	[AUDIT_DATE_CREATED] [datetime] NOT NULL,
	[AUDIT_DATE_CHANGED] [datetime] NOT NULL,
	[AUDIT_EMPLOYEE_NO] [numeric](38, 0) NOT NULL,
	[STATUS] [nvarchar](1) NOT NULL,
	[DATE_LAST_GT] [datetime] NULL,
	[CHANGE_CODE] [varchar](2) DEFAULT 'I' NOT NULL,
	[CHANGE_DATE_TIME] [datetime] DEFAULT GETDATE() NOT NULL,
	[WORKFLOW_CODE] [varchar](2) NOT NULL DEFAULT ('L')
) ON [PRIMARY]
