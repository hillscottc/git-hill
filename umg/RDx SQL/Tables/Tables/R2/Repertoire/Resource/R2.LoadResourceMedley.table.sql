CREATE TABLE [R2].[LoadResourceMedley](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[RESOURCE_RESOURCE_LINK_ID] [numeric](38, 0) NOT NULL,
	[RESOURCE_ID] [numeric](38, 0) NULL,
	[CHILD_RESOURCE_ID] [numeric](38, 0) NOT NULL,
	[SEQUENCE_NO] [numeric](38, 0) NOT NULL,
	[PAUSE_TIME] [numeric](38, 0) NULL,
	[FORMATTED_PAUSE_TIME] [nvarchar](4000) NULL,
	[ISRC] [nvarchar](12) NULL,
	[CHILD_ISRC] [nvarchar](12) NULL,
	[CHANGE_CODE] [varchar](2) DEFAULT 'C' NOT NULL,
	[CHANGE_DATE_TIME] [datetime] DEFAULT getdate() NOT NULL,
	[WORKFLOW_CODE] [varchar](2) DEFAULT 'E' NOT NULL
) ON [PRIMARY]
