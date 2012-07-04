-- Represents a transform session.
CREATE TABLE [DRA].[TransformLogSession]
(
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Logger] nvarchar(1000) NOT NULL,
	[StartTime] datetime null default(getdate()),
	[EndTime] datetime null default(getdate()),
	-- P - Pending, C - Complete
	[Status] varchar(2) not NULL default('P') 
) ON [PRIMARY]
