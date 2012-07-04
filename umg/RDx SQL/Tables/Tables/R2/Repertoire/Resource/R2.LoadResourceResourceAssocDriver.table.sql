CREATE TABLE [R2].[LoadResourceResourceAssocDriver]
(
	[RESOURCE_RESOURCE_ASSOC_ID] [numeric](38, 0) NOT NULL,
	[WORKFLOW_CODE] [varchar](2) NOT NULL DEFAULT ('L'),
	[CHANGE_CODE] [varchar](2) NOT NULL DEFAULT ('I'),
	[CHANGE_DATE_TIME] [datetime] NOT NULL DEFAULT (getdate())
) ON [PRIMARY]