CREATE TABLE [CPRS].[ProductDriver]
(
	[ProductID] [bigint] NOT NULL,
	[UPC] [nvarchar](14) NOT NULL,
	[CountryID] [bigint] NULL,
	[CountryName] [nvarchar](255) NOT NULL,
	[CountryISOCode] [nvarchar](3) NULL,
	[PhysicalReleaseDate] [datetime] NULL,
	[DigitalReleaseDate] [datetime] NULL,
	[RMSReleaseID] [numeric](38, 0) NULL,
	[WorkflowCode] [varchar](2) NOT NULL DEFAULT ('E')
) 
ON [PRIMARY];
