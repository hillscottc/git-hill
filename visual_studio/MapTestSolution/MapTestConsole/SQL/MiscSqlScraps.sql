

select * from DistanceResults;
select *  from VendorTestResults;
select *  from TestItems;
select *  from Vendors;

-- gets the difs tween osm and osm nozip
select * from TestSummary
  where (Vendor1 in ))
  and (SecondVendorTestResultId in 
		(select id from VendorTestResults where VendorId in(2,3)))
	


