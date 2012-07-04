CREATE TABLE CPRS.LoadProductTerritoryRightDriver
(
	[ID] bigint IDENTITY(1,1) NOT NULL,
	ProductID bigint NOT NULL,
	ProductMedium varchar(1) NOT NULL,
	ISO nvarchar(3) NOT NULL,
	
	ChangeCode varchar(2) NOT NULL DEFAULT ('I'),
	ChangeDatetime datetime NOT NULL DEFAULT (getdate()),
	WorkflowCode varchar(2) NOT NULL DEFAULT ('L')
);
