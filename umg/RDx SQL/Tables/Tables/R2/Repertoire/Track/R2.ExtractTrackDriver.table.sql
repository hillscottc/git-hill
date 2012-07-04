CREATE TABLE [R2].[ExtractTrackDriver]
(
	[RELEASE_ID] [numeric](38, 0) NULL,
	[RESOURCE_ID] [numeric](38, 0) NULL,
	[TRACK_ID] [numeric](38, 0) NULL,
	[WORKFLOW_CODE] [varchar](2) NOT NULL DEFAULT ('E'),
	[ROW_CREATE_DATE_TIME] [datetime] NOT NULL DEFAULT (getdate())	
) ON [PRIMARY]