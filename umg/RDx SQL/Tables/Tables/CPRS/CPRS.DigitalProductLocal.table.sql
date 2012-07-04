CREATE TABLE CPRS.DigitalProductLocal
(
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	ProductID bigint NOT NULL,
	UPC nvarchar(14) NULL,
	GRID nvarchar(18) NULL,

	LLVersionID bigint NOT NULL,
	
	CountryISO nvarchar(3) NOT NULL,
	CountryName nvarchar(255) NOT NULL,
	
	ReleaseDate  nvarchar(30) NULL,
	
	CPRSReleasingLabelID  bigint NULL,
	CPRSReleasingLabel nvarchar(max) NULL,
	
	ChangeCode varchar(2) NOT NULL DEFAULT ('I'),
	ChangeDatetime datetime NOT NULL DEFAULT (getdate()),
	WorkflowCode varchar(2) NOT NULL DEFAULT ('L')
);
