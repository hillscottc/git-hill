USE [MapTestDb]
GO

/****** Object:  Table [dbo].[MapTestResult]    Script Date: 09/21/2012 10:52:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MapTestResult]') AND type in (N'U'))
DROP TABLE [dbo].[MapTestResult]
GO

USE [MapTestDb]
GO

/****** Object:  Table [dbo].[MapTestResult]    Script Date: 09/21/2012 10:52:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MapTestResult](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[campId] [int] NULL,
	[resellId] [int] NULL,
	[address] [varchar](100) NULL,
	[noZipAddress] [varchar](100) NULL,
	[zipDisplay] [varchar](200) NULL,
	[zipLongitude] [decimal](10, 7) NULL,
	[zipLatitude] [decimal](10, 7) NULL,
	[noZipDisplay] [varchar](200) NULL,
	[noZipLongitude] [decimal](10, 7) NULL,
	[noZipLatitude] [decimal](10, 7) NULL,
	[distance] [float] NULL,
 CONSTRAINT [PK_MapTest] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

