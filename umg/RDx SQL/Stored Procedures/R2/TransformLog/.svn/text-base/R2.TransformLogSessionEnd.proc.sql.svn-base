CREATE PROCEDURE R2.TransformLogSessionEnd (@id bigint)
AS
	update R2.TransformLogSession 
	set EndTime = getdate(), [Status] = 'C'
	where id = @id;