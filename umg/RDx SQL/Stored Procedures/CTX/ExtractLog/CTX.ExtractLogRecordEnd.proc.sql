CREATE PROCEDURE CTX.ExtractLogRecordEnd (@id bigint)
AS
	-- does nothing when @id is 0
	update CTX.ExtractLog 
	set EndTime = getdate(), [Status] = 'C'
	where id = @id;