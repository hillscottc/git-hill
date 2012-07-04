CREATE PROCEDURE R2.ExtractLogRecordEnd (@id bigint)
AS
	update R2.ExtractLog 
	set EndTime = getdate(), [Status] = 'C'
	where id = @id;