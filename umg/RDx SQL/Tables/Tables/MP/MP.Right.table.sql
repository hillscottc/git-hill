CREATE TABLE MP.[Right]
(
	[ID] bigint IDENTITY(1,1) NOT NULL,
	RightID smallint NOT NULL,
	[Name] nvarchar(255) NOT NULL,
	ChangeCode varchar(2) NOT NULL DEFAULT ('I'),
	ChangeDatetime datetime NOT NULL DEFAULT (getdate()),
	WorkflowCode varchar(2) NOT NULL DEFAULT ('L')	
);
