CREATE TABLE MP.LoadReleaseDriver
(
	[ID] bigint IDENTITY(1,1) NOT NULL,
	UPC nvarchar(14) NOT NULL,
	CompanyID bigint NOT NULL,
	ChangeCode varchar(2) NOT NULL DEFAULT ('I'),
	ChangeDatetime datetime NOT NULL DEFAULT (getdate()),
	WorkflowCode varchar(2) NOT NULL DEFAULT ('L')
);
