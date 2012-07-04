CREATE TABLE CPRS.ProductTerritoryRight
(
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	ProductID bigint NOT NULL,
	UPC nvarchar(14) NOT NULL,
	GRID nvarchar(18) NULL,
	
     --<s:simpleType name="CPRSProductMedium">
        --<s:restriction base="s:string">
          --<s:enumeration value="Physical" />
          --<s:enumeration value="Digital" />
        --</s:restriction>
      --</s:simpleType>	
	ProductMedium varchar(1) NOT NULL,
	ISO nvarchar(3) NOT NULL,
	
	ChangeCode varchar(2) NOT NULL DEFAULT ('I'),
	ChangeDatetime datetime NOT NULL DEFAULT (getdate()),
	WorkflowCode varchar(2) NOT NULL DEFAULT ('L')
) 
ON [PRIMARY];
