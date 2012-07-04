CREATE PROCEDURE MP.ExtractLogRecordEnd (@id bigint, @snapshotTimeUTC datetime)
AS
	update MP.ExtractLog 
	set SnapshotTimeUTC = @snapshotTimeUTC, EndTime = getdate(), [Status] = 'C'
	where id = @id;