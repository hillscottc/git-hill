-- Represents a transform task. Each task is linked to a transform session. 
-- Used for logging record counts. 
CREATE TABLE [MP].[TransformLogTask]
(
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[SessionID] [bigint] NOT NULL,
	[Logger] nvarchar(1000) NOT NULL,
	-- Number of rows affected by this task
	[Rows] bigint NULL default(0),
	-- I - Insert, U - Update, D - Delete
	[WorkflowCode] varchar(2) not NULL
) ON [PRIMARY]
