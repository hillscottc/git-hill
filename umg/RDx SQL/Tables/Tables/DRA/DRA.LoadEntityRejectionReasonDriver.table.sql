CREATE TABLE [DRA].[LoadEntityRejectionReasonDriver]
(
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ENTITY_CLEARANCE_ID] [numeric](38, 0) NOT NULL,
	[REJECTION_REASON_ID] [numeric](38, 0) NOT NULL,
	[WORKFLOW_CODE] [varchar](2) NOT NULL DEFAULT ('L'),
	[CHANGE_CODE] [varchar](2) NOT NULL DEFAULT ('I'),
	[CHANGE_DATE_TIME] [datetime] NOT NULL DEFAULT (getdate())
) ON [PRIMARY]