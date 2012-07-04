CREATE TABLE [GDRS].[Release](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[UPC] [nvarchar](14) NOT NULL,
	[Release_ID] [numeric](38, 0) NULL,
	[ReleaseDate] [datetime] NULL,
	[Status] [nvarchar](14) NULL,
	[TerritorialRights] [nvarchar](max) NOT NULL,
	[ReleasingCountry] [nvarchar](14) NULL,
	[SoundtrackInd] [char](1) NOT NULL,
	[company_id] [numeric](10, 0) NULL,
	[ChangeCode] [varchar](2) NOT NULL CONSTRAINT [DF__Right__ChangeCod__1E6F845E]  DEFAULT ('I'),
	[ChangeDatetime] [datetime] NOT NULL CONSTRAINT [DF__Right__ChangeDat__1F63A897]  DEFAULT (getdate()),
	[WorkflowCode] [varchar](2) NOT NULL CONSTRAINT [DF__Right__WorkflowC__2057CCD0]  DEFAULT ('L')
) ON [PRIMARY]
