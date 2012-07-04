CREATE TABLE [GDRS].[LoadRelease](
	[UPC] [nvarchar](14) NOT NULL,
	[Release_ID] [numeric](38, 0) NULL,
	[ReleaseDate] [datetime] NULL,
	[Status] [nvarchar](14) NULL,
	[TerritorialRights] [nvarchar](max) NOT NULL,
	[ReleasingCountry] [nvarchar](14) NULL,
	[SoundtrackInd] [bit] NOT NULL,
	[Company_ID] [bigint] NULL,
	[loadrelease_id] [bigint] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]
