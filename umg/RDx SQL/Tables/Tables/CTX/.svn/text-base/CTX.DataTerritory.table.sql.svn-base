CREATE TABLE [CTX].[DataTerritory]
(
	[CONTRACT_ID] numeric (38, 0) NOT NULL,
	[PROPERTY_NM] [nvarchar](100) NULL,
	[UNIQUE_ID] [nvarchar](40) NULL,
	[TERRITORY_TYPE] [nvarchar](9) NULL,
	[NAME] [nvarchar](255) NULL,
	[CHANGE_CODE] [varchar](2) DEFAULT 'I' NOT NULL,
	[CHANGE_DATE_TIME] [datetime] DEFAULT GETDATE() NOT NULL,
	[WORKFLOW_CODE] [varchar](2) NOT NULL DEFAULT ('L')
) ON [PRIMARY]