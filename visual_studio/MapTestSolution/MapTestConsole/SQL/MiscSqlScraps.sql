
USE MapTestResultDb

--select * from DistanceResults;
select *  from VendorTestResults;
select *  from TestItems;
select *  from Vendors;
GO


SELECT COUNT(*) FROM TestItems

-- PRINT COUNT OF RESULTS FOR SPECIFIED VENDORS
DECLARE @vendor_name varchar(20)
DECLARE @vendor_id int
DECLARE	@success int

SET @vendor_name = 'OpenStreetMaps'
SELECT @vendor_id  = [Id] FROM vendors WHERE [name] = @vendor_name
PRINT @vendor_name
SELECT @success = COUNT(*) from VendorTestResults v WHERE v.VendorId = @vendor_id
PRINT '  Succesful queries:' + cast(@success as varchar(20))

SET @vendor_name = 'MapQuest'
SELECT @vendor_id  = [Id] FROM vendors WHERE [name] = @vendor_name
PRINT @vendor_name
SELECT @success = COUNT(*) from VendorTestResults v WHERE v.VendorId = @vendor_id
PRINT '  Succesful queries:' + cast(@success as varchar(20))

	

