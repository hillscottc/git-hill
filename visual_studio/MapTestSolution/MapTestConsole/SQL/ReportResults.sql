USE [MapTestResultDb]
GO

DECLARE	@vendorName varchar(20) 
SET 	@vendorName = 'Google'

DECLARE	@return_value int
EXEC	@return_value = [dbo].[ResultCountsByVendorName]
		@vendor_name = @vendorName
--SELECT	'Return Value' = @return_value
GO


DECLARE	@vendorName varchar(20) 
SET 	@vendorName = 'MapQuest'

DECLARE	@return_value int
EXEC	@return_value = [dbo].[ResultCountsByVendorName]
		@vendor_name = @vendorName
--SELECT	'Return Value' = @return_value
GO


DECLARE	@vendorName varchar(20) 
SET 	@vendorName = 'OpenStreetMaps'

DECLARE	@return_value int
EXEC	@return_value = [dbo].[ResultCountsByVendorName]
		@vendor_name = @vendorName
--SELECT	'Return Value' = @return_value
GO

