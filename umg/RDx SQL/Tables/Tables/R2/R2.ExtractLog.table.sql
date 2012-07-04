CREATE TABLE [R2].[ExtractLog]
(
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[SnapshotTimePDT] [datetime] NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
	[Status] [nvarchar](50) NOT NULL
) ON [PRIMARY]
