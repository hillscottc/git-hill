﻿CREATE TABLE [CTX].[LoadDataRepertoireDriver]
(
	[CONTRACT_ID] numeric (38, 0) NOT NULL,
	[REPERTOIRE_TYPE] [nvarchar](6) NOT NULL,
	[UNIQUE_ID] numeric (38, 0) NOT NULL,
	[WORKFLOW_CODE] [varchar](2) NOT NULL DEFAULT ('L'),
	[CHANGE_CODE] [varchar](2) NOT NULL DEFAULT ('I'),
	[CHANGE_DATE_TIME] [datetime] NOT NULL DEFAULT (getdate())
) ON [PRIMARY]