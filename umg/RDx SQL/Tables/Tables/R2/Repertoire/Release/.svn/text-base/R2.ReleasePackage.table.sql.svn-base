CREATE TABLE [R2].[ReleasePackage](
	[RELEASE_ID] [numeric](38, 0) NOT NULL,
	[COMPONENT_RELEASE_ID] [numeric](38, 0) NOT NULL,
	[SEQUENCE_NO] [numeric](38, 0) NOT NULL,
	[UPC] [nvarchar](14) NULL,
	[GRID] [nvarchar](18) NULL,
	[COMPONENT_UPC] [nvarchar](14) NULL,
	[COMPONENT_GRID] [nvarchar](18) NULL,
	[CHANGE_CODE] [varchar](2) DEFAULT 'I' NOT NULL,
	[CHANGE_DATE_TIME] [datetime] DEFAULT GETDATE() NOT NULL,
	[WORKFLOW_CODE] [varchar](2) NOT NULL DEFAULT ('L')
) ON [PRIMARY]