CREATE PROCEDURE MP.TransformLogSessionEnd (@id bigint)
AS
	update MP.TransformLogSession 
	set EndTime = getdate(), [Status] = 'C'
	where id = @id;