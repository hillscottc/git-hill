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


-- PRINT COUNT OF RESULTS FOR SPECIFIED VENDOR
DECLARE @vendor_name varchar(20) = 'OpenStreetMaps'
DECLARE @vendor_id int
DECLARE	@success int
SELECT @vendor_id  = [Id] FROM vendors WHERE [name] = @vendor_name
PRINT @vendor_name
SELECT @success = COUNT(*) from VendorTestResults v WHERE v.VendorId = @vendor_id
PRINT '  Succesful queries:' + cast(@success as varchar(20))
	