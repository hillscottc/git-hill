CREATE TABLE [DRA].[RejectionReason]
(
	[REJECTION_REASON_ID] [numeric](38, 0) NOT NULL,
	[NAME] [nvarchar](50) NOT NULL,
	[SEQUENCE_NO] [numeric](38, 0) NULL,
	[CHANGE_CODE] [varchar](2) DEFAULT 'I' NOT NULL,
	[CHANGE_DATE_TIME] [datetime] DEFAULT GETDATE() NOT NULL,
	[WORKFLOW_CODE] [varchar](2) NOT NULL DEFAULT ('L')
) ON [PRIMARY]
