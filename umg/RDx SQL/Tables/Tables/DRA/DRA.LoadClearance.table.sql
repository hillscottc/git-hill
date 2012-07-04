CREATE TABLE [DRA].[LoadClearance]
(
	[CLEARANCE_ID] [numeric](38, 0) NOT NULL,
	[NAME] [nvarchar](30) NOT NULL,
	[ABBREVIATED_NAME] [nvarchar](2) NOT NULL,
	[SELECTION_TYPE] [nvarchar](1) NOT NULL,
	[USE_FLAG] [nvarchar](1) NULL
) ON [PRIMARY]