CREATE TABLE [ADMIN].[DataIngestion](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SourceID] [nchar](12) NOT NULL,
	[RecordsReceived] [int] NULL,
	[RecordsInserted] [int] NULL,
	[RecordsUpdated] [int] NULL,
	[RecordsDeleted] [int] NULL,
	[RecordsErrored] [int] NULL,
	[StartRunDateTime] [smalldatetime] NULL,
	[EndRunDateTime] [smalldatetime] NULL,
	[ProcessStep] [nvarchar](50) NULL,
	[Process] [nvarchar](100) NULL
) ON [PRIMARY];
