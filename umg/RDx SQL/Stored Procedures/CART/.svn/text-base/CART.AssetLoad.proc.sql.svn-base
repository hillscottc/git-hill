CREATE PROCEDURE [CART].[AssetLoad]
	@FileName NVarchar(500),
	@retVal int = -1 OUTPUT 
AS
BEGIN
	DECLARE @AssetInsertCount integer;
	DECLARE @AssetUpdateCount integer;
	DECLARE @DCInsertCount integer;
	DECLARE @DCUpdateCount integer;

	SET @Filename = RIGHT(@FileName, CHARINDEX('\', REVERSE(@FileName))-1);

	-- Do inserts
	insert into CART.Asset
	select distinct LoadAsset.* 
	from CART.LoadAsset
	inner join CART.AssetDriver
	on LoadAsset.ISRC = AssetDriver.ISRC	
	and LoadAsset.UPC = AssetDriver.UPC	
	and AssetDriver.UpdateCode = 'I'
	and AssetDriver.WorkFlowCode = 'E'
	order by LoadCreateDate;

	SET @AssetInsertCount  = @@rowcount;

	insert into CART.DistributionChannel 
		select distinct Asset.Asset_ID,DC.*
		from  CART.LoadDistributionChannel DC 
		inner join  CART.Asset
		on Asset.isrc = dc.isrc		
		and Asset.upc = dc.upc
		inner join CART.AssetDriver
		on Asset.isrc = AssetDriver.isrc		
		and Asset.upc = AssetDriver.upc
		and AssetDriver.UpdateCode = 'I'
		and AssetDriver.WorkFlowCode = 'E'
		order by LoadCreateDate;

	SET @DCInsertCount = @@rowcount;

	Update CART.AssetDriver 
	Set WorkFlowCode = 'L'
	where UpdateCode = 'I';


	delete from CART.DistributionChannel
	where ASSET_ID in ( select distinct ASSET_ID
						from CART.AssetDriver 
						where UpdateCode = 'U');

	delete from CART.Asset 
	where ASSET_ID in ( select distinct ASSET_ID
						from CART.AssetDriver 
						where UpdateCode = 'U');

	insert into CART.Asset
		select distinct LoadAsset.* 
		from CART.LoadAsset
		inner join CART.AssetDriver
		on LoadAsset.ISRC = AssetDriver.ISRC	
		and LoadAsset.UPC = AssetDriver.UPC	
		and AssetDriver.UpdateCode = 'U'
		and AssetDriver.WorkFlowCode = 'E'
		order by LoadCreateDate;

	SET @AssetUpdateCount  = @@rowcount;

	insert into CART.DistributionChannel 
		select distinct AssetDriver.Asset_ID,DC.*
		from  CART.LoadDistributionChannel DC 
		inner join  CART.AssetDriver
		on AssetDriver.isrc = dc.isrc
		and AssetDriver.upc = dc.upc
		and AssetDriver.UpdateCode = 'U'
		and AssetDriver.WorkFlowCode = 'E'
		order by LoadCreateDate;

	SET @DCUpdateCount = @@rowcount;
		
	Update CART.AssetDriver 
	Set WorkFlowCode = 'L'
	where UpdateCode = 'U'
	and WorkFlowCode = 'E';

	update admin.dataingestion 
	set RecordsInserted = @AssetInsertCount,
		RecordsUpdated = @AssetUpdateCount,
		RecordsDeleted = 0,
		RecordsErrored = 0,
		EndRunDateTime = GetDate()
	where process = @filename
	and ProcessStep = 'CART.LoadAsset';

	update admin.dataingestion 
	set RecordsInserted = @DCInsertCount,
		RecordsUpdated = @DCUpdateCount,
		RecordsDeleted = 0,
		RecordsErrored = 0,
		EndRunDateTime = GetDate()
	where process = @filename
	and ProcessStep = 'CART.LoadDistributionChannel';

	return @@rowcount	
END

