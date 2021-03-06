﻿CREATE TABLE [R2].[ConfigResourceTypeLink](
	[CONFIG_ID] [nvarchar](6) NOT NULL,
	[RESOURCE_LOCATION] [nvarchar](1) NOT NULL,
	[RESOURCE_TYPE] [nvarchar](6) NOT NULL,
	[AVAILABILITY_CHECK_REQUIRED] [nvarchar](1) NOT NULL,
	[CHANGE_CODE] [varchar](2) DEFAULT 'I' NOT NULL,
	[CHANGE_DATE_TIME] [datetime] DEFAULT GETDATE() NOT NULL,
	[WORKFLOW_CODE] [varchar](2) NOT NULL DEFAULT ('L')
) ON [PRIMARY]
