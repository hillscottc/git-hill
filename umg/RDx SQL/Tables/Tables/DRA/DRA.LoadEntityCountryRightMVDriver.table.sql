﻿CREATE TABLE [DRA].[LoadEntityCountryRightMVDriver]
(
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ENTITY_CLEARANCE_SET_ID] [numeric](38, 0) NOT NULL,
	[COUNTRY_ID] [nvarchar](2) NOT NULL,
	[WORKFLOW_CODE] [varchar](2) NOT NULL DEFAULT ('L'),
	[CHANGE_CODE] [varchar](2) NOT NULL DEFAULT ('I'),
	[CHANGE_DATE_TIME] [datetime] NOT NULL DEFAULT (getdate())
) ON [PRIMARY]