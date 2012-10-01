

select * from DistanceResults;
select *  from VendorTestResults;
select *  from TestItems;
select *  from Vendors;


SELECT DISTINCT  t.[Address], v.Name, vtr.Latitude, vtr.Longitude
FROM         VendorTestResults as vtr
join Vendors as v on vtr.VendorId = v.Id
join TestItems as t on t.Id = vtr.TestItemId

select COUNT(*) from VendorTestResults 
where Latitude <> -1 and Longitude <> -1
and VendorId = 1

select COUNT(*) from VendorTestResults 
where Latitude <> -1 and Longitude <> -1
and VendorId = 2

select COUNT(*) from VendorTestResults 
where Latitude <> -1 and Longitude <> -1
and VendorId = 3

select COUNT(*) from VendorTestResults 
where Latitude <> -1 and Longitude <> -
and VendorId = 4