CREATE TABLE [MP].[ExtractLog]
(
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[SnapshotTimeUTC] [datetime] NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
	[Status] [nvarchar](50) NOT NULL
) ON [PRIMARY]
