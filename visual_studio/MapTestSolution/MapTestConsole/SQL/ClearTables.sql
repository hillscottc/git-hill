
---
--- Deletes all records except the Vendor list.
---

use MapTestResultDb
go

delete from DistanceResults;
delete from VendorTestResults;
delete from TestItems;
--delete from Vendors where [Id] > 5
go

