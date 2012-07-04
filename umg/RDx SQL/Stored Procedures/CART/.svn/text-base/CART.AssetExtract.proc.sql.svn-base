CREATE PROCEDURE [CART].[AssetExtract]
	@FileName NVarchar(500),
	@retVal int = -1 OUTPUT 
AS
BEGIN

TRUNCATE TABLE CART.LoadAsset;
TRUNCATE TABLE CART.LoadDistributionChannel;

DECLARE @InsertCount integer;
DECLARE @sSQL NVarchar(2000)
SET @sSQL= "
DECLARE @hDoc int
DECLARE @xml xml

set @xml=(select convert(xml,BulkColumn, 2)
From openrowset(Bulk'"+ @FileName + "', single_blob) [rowsetresults]);

exec sp_xml_preparedocument @hDoc OUTPUT, @xml;

INSERT INTO CART.LoadAsset
SELECT 
Isrc,
Upc,
ArtistConsentRequired,
CommercialRights,
Controlled,
ControlledType,
SyncGrant,
SyncGrantType,
Territory,
LabelExclusive,
ExclusivePartner,
ExclusiveWeeks,
ExclusiveStart,
ExclusiveEnd,
GuestVideoAppearance,
GuestAppearanceInfo,
RestrictFullLengthEdit,
LoadCreateDate
FROM OPENXML(@hDoc, 'CARTUpdateNotification/Body/Assets/Asset',2)
WITH (Isrc NVarchar(25),
Upc NVarchar(25),
ArtistConsentRequired NVarchar(10),
CommercialRights NVarchar(10),
Controlled NVarchar(10),
ControlledType NVarchar(30),
SyncGrant NVarchar(10),
SyncGrantType NVarchar(10),
Territory NVarchar(255),
LabelExclusive NVarchar(10),
ExclusivePartner NVarchar(10),
ExclusiveWeeks NVarchar(10),
ExclusiveStart NVarchar(10),
ExclusiveEnd NVarchar(10),
GuestVideoAppearance NVarchar(10),
GuestAppearanceInfo NVarchar(255),
RestrictFullLengthEdit NVarchar(10),
LoadCreateDate Datetime '../../../Header'
);

INSERT INTO CART.LoadDistributionChannel
SELECT 
	Isrc,
	Upc,
	Name,
	Status,
	WorkflowStatus,
	ClearanceComments,
	Reason,
	Explanation,
	Clearance,
	LoadCreateDate
FROM OPENXML(@hDoc, 'CARTUpdateNotification/Body/Assets/Asset/DistributionChannels/DistributionChannel',2)
WITH (
	Isrc NVarchar(25) '../../Isrc',
	Upc NVarchar(25) '../../Upc',	
	Name NVarchar(50),
	Status NVarchar(50),
	WorkflowStatus NVarchar(25),
	ClearanceComments NVarchar(255),
	Reason NVarchar(255),
	Explanation NVarchar(255),
	Clearance NVarchar(25),
	LoadCreateDate Datetime '../../../../../Header'
) 

exec sp_xml_removedocument @hDoc "; 

EXEC sp_executesql @sSQL 
	
select @InsertCount = count(*) from CART.LoadAsset;

set @filename = RIGHT(@FileName, CHARINDEX('\', REVERSE(@FileName))-1);

INSERT INTO Admin.DataIngestion (SourceID,RecordsReceived,StartRunDateTime,ProcessStep,Process)
values ('CART',@InsertCount,getdate(),'CART.LoadAsset',@filename);

select @InsertCount = count(*) from CART.LoadDistributionChannel;

INSERT INTO Admin.DataIngestion (SourceID,RecordsReceived,StartRunDateTime,ProcessStep,Process)
values ('CART',@InsertCount,getdate(),'CART.LoadDistributionChannel',@filename);

return @@rowcount

END
