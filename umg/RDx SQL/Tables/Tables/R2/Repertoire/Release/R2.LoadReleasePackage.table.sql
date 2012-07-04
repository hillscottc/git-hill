CREATE TABLE [R2].[LoadReleasePackage](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[RELEASE_ID] [numeric](38, 0) NOT NULL,
	[COMPONENT_RELEASE_ID] [numeric](38, 0) NOT NULL,
	[SEQUENCE_NO] [numeric](38, 0) NOT NULL,
	[UPC] [nvarchar](14) NULL,
	[GRID] [nvarchar](18) NULL,
	[COMPONENT_UPC] [nvarchar](14) NULL,
	[COMPONENT_GRID] [nvarchar](18) NULL,
	[CHANGE_CODE] [varchar](2) DEFAULT 'I' NOT NULL,
	[CHANGE_DATE_TIME] [datetime] DEFAULT getdate() NOT NULL,
	[WORKFLOW_CODE] [varchar](2) DEFAULT 'E' NOT NULL
) ON [PRIMARY]