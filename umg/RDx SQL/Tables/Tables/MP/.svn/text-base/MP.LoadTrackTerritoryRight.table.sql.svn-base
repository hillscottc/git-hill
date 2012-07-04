CREATE TABLE MP.LoadTrackTerritoryRight
(
	[ID] bigint IDENTITY(1,1) NOT NULL,
	UPC nvarchar(14) NOT NULL,
	ISRC nvarchar(12) NOT NULL,	
	RightID smallint NOT NULL,
	TerritoryISOCode nvarchar(3),
	ChangeCode varchar(2) NOT NULL DEFAULT ('I'),
	ChangeDatetime datetime NOT NULL DEFAULT (getdate()),
	WorkflowCode varchar(2) NOT NULL DEFAULT ('E')
);
