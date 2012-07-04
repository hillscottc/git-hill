CREATE TABLE MP.LoadRelease
(
	[ID] bigint IDENTITY(1,1) NOT NULL,
	UPC nvarchar(14) NOT NULL,
	AccountID bigint NOT NULL,
	CompanyID bigint NOT NULL,
	DivisionID bigint NOT NULL,
	LabelID bigint NOT NULL,
	ExclusiveInfo nvarchar(max) NULL,
	ChangeCode varchar(2) NOT NULL DEFAULT ('I'),
	ChangeDatetime datetime NOT NULL DEFAULT (getdate()),
	WorkflowCode varchar(2) NOT NULL DEFAULT ('E')
);
