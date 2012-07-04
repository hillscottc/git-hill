CREATE TABLE [CPRS].[Subscription](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ProductID] [bigint] NOT NULL,
	[AreaOfInterest] [bigint] NOT NULL,
	[MessageCreationTimeCET] [datetime] NOT NULL,
	[MessageReceiveTime] [datetime] default(getdate()) NOT NULL,
	[WorkflowCode] [varchar](50) default('E') NOT NULL,
) ON [PRIMARY]