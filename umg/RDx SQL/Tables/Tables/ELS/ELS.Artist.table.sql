CREATE TABLE [ELS].[Artist](
	[ArtistRequired_ID] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](150) NULL,
	[Contract_ID] [nvarchar](50) NULL,
	[ISRC] [nvarchar](50) NULL,
	[Contract_Name] [nvarchar](150) NULL,
	[ArtistFullName] [nvarchar](150) NULL,
	[Artist_Consent_Required] [nvarchar](50) NULL
) ON [PRIMARY]
