CREATE PROCEDURE [CART].[AssetDriverLoad]
	@retVal int = -1 OUTPUT 
AS
BEGIN
	insert into CART.AssetDriver
	select NULL,ISRC, UPC, 'I','E',LoadCreateDate
	from CART.LoadAsset la
	where not exists
	(select ISRC, UPC
	 from CART.Asset a
	 where a.ISRC = la.ISRC	
	 and a.UPC = la.UPC)

	insert into CART.AssetDriver	
	select a.Asset_ID,a.ISRC, a.UPC, 'U','E',la.LoadCreateDate
	from CART.LoadAsset la
	inner join CART.Asset a
	on a.ISRC = la.ISRC	
	and a.UPC = la.UPC

	return @@rowcount	
END



