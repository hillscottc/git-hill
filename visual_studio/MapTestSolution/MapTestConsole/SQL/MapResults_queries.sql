/****** Queries to examine results in MapTestResult table. ******/
use MapTestDb
go

SELECT distinct [resellId],[address],[zipDisplay],[noZipDisplay],[distance] FROM [MapTestResult]


select COUNT(*) as 'Distinct records' 
from (SELECT distinct [resellId],[address],[zipDisplay],[noZipDisplay],[distance] FROM [MapTestResult]) as myquery

select COUNT (*) as 'Count null results for query WITHOUT zip' 
from (SELECT distinct [resellId],[address],[zipDisplay],[noZipDisplay],[distance] FROM [MapTestResult]  where noZipDisplay is null) as myquery  

select COUNT (*) as 'Count null results for query WITH ZIP' 
from (SELECT distinct [resellId],[address],[zipDisplay],[noZipDisplay],[distance] FROM [MapTestResult]  where zipDisplay is null) as myquery  

select COUNT (*) as 'Count null results for query WITH OR WITHOUT ZIP' 
from (SELECT distinct [campId],[resellId],[address],[zipDisplay],[noZipDisplay],[distance] FROM [MapTestResult]  where noZipDisplay is null and zipDisplay is null) as myquery  

select COUNT (*) as 'Count results with distance > 15' 
from (SELECT distinct [campId],[resellId],[address],[zipDisplay],[noZipDisplay],[distance] FROM [MapTestResult] where [distance] > 15) as myquery  

--delete from [MapTestDb].[dbo].[MapTestResult]