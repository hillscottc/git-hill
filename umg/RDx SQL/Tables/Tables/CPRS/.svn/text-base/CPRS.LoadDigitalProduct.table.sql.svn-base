CREATE TABLE CPRS.LoadDigitalProduct
(
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	ProductID bigint NOT NULL,
	UPC nvarchar(14) NULL,
	GRID nvarchar(18) NULL,
	ReleaseDate datetime NULL,
	CPRSVersionTitle nvarchar(max) NULL,
	
    --<s:simpleType name="ProductType">
        --<s:restriction base="s:string">
          --<s:enumeration value="Undefined" />
          --<s:enumeration value="Promo" />
          --<s:enumeration value="Commercial" />
          --<s:enumeration value="Exclusive" />
          --<s:enumeration value="Import" />
          --<s:enumeration value="IMS" />
          --<s:enumeration value="Distribution" />
          --<s:enumeration value="ePD" />
        --</s:restriction>
      --</s:simpleType>	
	CPRSProductType nvarchar(50) NULL,
	
  --<s:simpleType name="ProductStatus">
    --<s:restriction base="s:string">
      --<s:enumeration value="Scheduled" />
      --<s:enumeration value="InProgress" />
      --<s:enumeration value="Deleted" />
      --<s:enumeration value="Error" />
    --</s:restriction>
  --</s:simpleType>
	CPRSStatus nvarchar(50) NULL,
	CPRSFormatCode nvarchar(50) NULL,
	CPRSFormat nvarchar(255) NULL,
	
	ExclusivityStartDate datetime NULL,
	ExclusivityEndDate datetime NULL,
	NumberOfTracks int NOT NULL,
	
	BizPartner nvarchar(max) NULL,
	BizPartners nvarchar(max) NULL,
	ActionsAfter nvarchar(max) NULL,
	
	AlbumOnly bit NULL,
	
	ChangeCode varchar(2) NOT NULL DEFAULT ('I'),
	ChangeDatetime datetime NOT NULL DEFAULT (getdate()),
	WorkflowCode varchar(2) NOT NULL DEFAULT ('E')
);
