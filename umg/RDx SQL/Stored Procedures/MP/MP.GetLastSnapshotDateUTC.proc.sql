CREATE PROCEDURE MP.GetLastSnapshotDateUTC(@date datetime output)
AS
-- get last successfull record
select 
	@date = SnapshotTimeUTC from MP.ExtractLog
where 
	ID = (select max(ID) from MP.ExtractLog where [Status] = 'C')
;
