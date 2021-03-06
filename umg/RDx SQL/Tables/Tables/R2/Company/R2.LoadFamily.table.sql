﻿CREATE TABLE [R2].[LoadFamily](
	[FAMILY_ID] [nvarchar](6) NOT NULL,
	[NAME] [nvarchar](100) NOT NULL,
	[AUDIT_DATE_CREATED] [datetime] NOT NULL,
	[AUDIT_DATE_CHANGED] [datetime] NOT NULL,
	[AUDIT_EMPLOYEE_NO] [numeric](38, 0) NOT NULL,
	[STATUS] [nvarchar](1) NOT NULL,
	[DATE_LAST_GT] [datetime] NULL,
	[UNIQUE_ID] [numeric](38, 0) NOT NULL
) ON [PRIMARY]