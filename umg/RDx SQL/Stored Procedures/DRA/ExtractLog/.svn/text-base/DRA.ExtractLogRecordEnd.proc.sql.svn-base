CREATE PROCEDURE DRA.ExtractLogRecordEnd (@id bigint)
AS
	-- does nothing when @id is 0
	update DRA.ExtractLog 
	set EndTime = getdate(), [Status] = 'C'
	where id = @id;