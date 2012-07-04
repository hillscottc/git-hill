CREATE TABLE [DRA].[Clearance]
(
	[CLEARANCE_ID] [numeric](38, 0) NOT NULL,
	[NAME] [nvarchar](30) NOT NULL,
	[ABBREVIATED_NAME] [nvarchar](2) NOT NULL,
	[SELECTION_TYPE] [nvarchar](1) NOT NULL,
	[USE_FLAG] [nvarchar](1) NULL,
	[CHANGE_CODE] [varchar](2) DEFAULT 'I' NOT NULL,
	[CHANGE_DATE_TIME] [datetime] DEFAULT GETDATE() NOT NULL,
	[WORKFLOW_CODE] [varchar](2) NOT NULL DEFAULT ('L')
) ON [PRIMARY]