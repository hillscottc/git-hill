CREATE TABLE CPRS.LoadDigitalProductDriver
(
	[ID] bigint IDENTITY(1,1) NOT NULL,
	ProductID bigint NOT NULL,
	ChangeCode varchar(2) NOT NULL DEFAULT ('I'),
	ChangeDatetime datetime NOT NULL DEFAULT (getdate()),
	WorkflowCode varchar(2) NOT NULL DEFAULT ('L')
);
