CREATE TABLE CPRS.LoadProduct
(
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	ProductID bigint NOT NULL,
	UPC nvarchar(14) NULL,
	GRID nvarchar(18) NULL,
	CPRSArtist nvarchar(max) NOT NULL, 
	CPRSTitle nvarchar(max) NOT NULL, 
	CPRSVersionTitle nvarchar(max) NULL, 
	
      --<s:simpleType name="ProductCoreAvailability">
        --<s:restriction base="s:string">
          --<s:enumeration value="PhysicalOnly" />
          --<s:enumeration value="DigitalOnly" />
          --<s:enumeration value="PhysicalAndDigital" />
        --</s:restriction>
      --</s:simpleType>
	Availability nvarchar(50) NOT NULL,
	LastUpdated datetime NOT NULL,
	HasExplicitLyrics bit NOT NULL,
	
      --<s:simpleType name="CPRSProductMusicType">
        --<s:restriction base="s:string">
          --<s:enumeration value="Pop" />
          --<s:enumeration value="ClassicsAndJazz" />
        --</s:restriction>
      --</s:simpleType>
	CPRSMusicType nvarchar(50) NOT NULL,
	
      --<s:simpleType name="CPRSProductMusicType">
        --<s:restriction base="s:string">
          --<s:enumeration value="Pop" />
          --<s:enumeration value="ClassicsAndJazz" />
        --</s:restriction>
      --</s:simpleType>
	CPRSManufacturingType nvarchar(50) NOT NULL,

	CPRSMarketingDivision nvarchar(max) NOT NULL,

	CPRSRepertoireOwnerLabelID bigint NOT NULL,
	CPRSRepertoireOwnerLabel nvarchar(max) NOT NULL,

	CPRSReleasingLabelID  bigint NULL,
	CPRSReleasingLabel nvarchar(max) NULL,
	
	ReleasingTerritoryISO nvarchar(3) NOT NULL,
	ReleasingTerritoryName nvarchar(255) NOT NULL,
	
	RMSProductID numeric(38, 0) NULL,
	RMSProjectID nvarchar(38) NULL,
	RMSConfigID numeric(38, 0) NULL,
	
	ChangeCode varchar(2) NOT NULL DEFAULT ('I'),
	ChangeDatetime datetime NOT NULL DEFAULT (getdate()),
	WorkflowCode varchar(2) NOT NULL DEFAULT ('E')	
);
