﻿CREATE TABLE [CTX].[LoadDataContract]
(
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ORGANIZATION_ID] numeric (38, 0) NOT NULL,
	[TEMPLATE_ID] numeric (38, 0) NOT NULL,
	[CONTRACT_ID] numeric (38, 0) NOT NULL,
	[CONTRACT_DESC] [nvarchar](255) NULL,
	[CONTRACT_RECORD_TYPE] [nvarchar](100) NULL,
	[CONTRACT_TYPE] [nvarchar](512) NULL,
	[UNIQUE_CONTRACT_NUMBER] [nvarchar](512) NULL,
	[ARTIST_ID] numeric (38, 0) NULL,
	[ARTIST] [nvarchar](512) NULL,
	[CONTRACT_SUMMARY_STATUS] [nvarchar](512) NULL,
	[COMPANY_ID] numeric (38, 0) NULL,
	[COMPANY] [nvarchar](512) NULL,
	[CONTRACT_EFFECTIVE_DATE] [nvarchar](4000) NULL,
	[CURRENT_ARTIST] [nvarchar](512) NULL,
	[END_OF_TERM_DATE] [nvarchar](4000) NULL,
	[HEADER_NOTES] [nvarchar](4000) NULL,
	[RIGHTS_PERIOD] [nvarchar](512) NULL,
	[RIGHTS_EXPIRY_DATE] [nvarchar](4000) NULL,
	[RIGHTS_EXPIRY_RULE] [nvarchar](4000) NULL,
	[RIGHTS_PERIOD_NOTES] [nvarchar](4000) NULL,
	[TERRITORIAL_RIGHTS_NOTES] [nvarchar](4000) NULL,
	[CHANGE_CODE] [varchar](2) DEFAULT 'C' NOT NULL,
	[CHANGE_DATE_TIME] [datetime] DEFAULT GETDATE() NOT NULL,
	[WORKFLOW_CODE] [varchar](2) DEFAULT 'E' NOT NULL
) ON [PRIMARY]