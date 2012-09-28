
--delete from DistanceResults;
--delete from VendorTestResults;
--delete from TestItems;
--delete from Vendors where [Id] > 3
  
select * from DistanceResults;
select *  from VendorTestResults;
select *  from TestItems;
select *  from Vendors;

-- gets the difs tween osm and osm nozip
SELECT d.[Address], e.Name as Vendor1, f.Name as Vendor2, a.Distance
  FROM DistanceResults a
  join VendorTestResults b on a.FirstVendorTestResultId = b.Id  
  join VendorTestResults c on a.SecondVendorTestResultId = c.Id  
  join TestItems d on b.TestItemId = d.Id
  join Vendors e on e.Id = b.VendorId
  join Vendors f on f.Id = c.VendorId
  where (FirstVendorTestResultId in 
		(select id from VendorTestResults where VendorId in(2,3)))
  and (SecondVendorTestResultId in 
		(select id from VendorTestResults where VendorId in(2,3)))
	


