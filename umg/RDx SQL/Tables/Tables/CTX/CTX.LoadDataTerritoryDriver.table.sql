CREATE TABLE [CTX].[LoadDataTerritoryDriver]
(
	[CONTRACT_ID] numeric (38, 0) NOT NULL,
	[TERRITORY_TYPE] [nvarchar](9) NULL,
	[UNIQUE_ID] [nvarchar](40) NULL,
	[WORKFLOW_CODE] [varchar](2) NOT NULL DEFAULT ('L'),
	[CHANGE_CODE] [varchar](2) NOT NULL DEFAULT ('I'),
	[CHANGE_DATE_TIME] [datetime] NOT NULL DEFAULT (getdate())
) ON [PRIMARY]