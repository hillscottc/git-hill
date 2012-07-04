CREATE TABLE [GDRS].[LoadReleaseDriver](
	[LoadRelease_ID] [bigint] NOT NULL,
	[UPC] [nvarchar](14) NOT NULL,
	[Company_ID] [bigint] NOT NULL,
	[Release_ID] [numeric](38, 0) NOT NULL,
	[ChangeCode] [varchar](2) NOT NULL CONSTRAINT [DF__LoadRelea__Chang__0E391C95]  DEFAULT ('I'),
	[ChangeDatetime] [datetime] NOT NULL CONSTRAINT [DF__LoadRelea__Chang__0F2D40CE]  DEFAULT (getdate()),
	[WorkflowCode] [varchar](2) NOT NULL CONSTRAINT [DF__LoadRelea__Workf__10216507]  DEFAULT ('L')
) ON [PRIMARY]
