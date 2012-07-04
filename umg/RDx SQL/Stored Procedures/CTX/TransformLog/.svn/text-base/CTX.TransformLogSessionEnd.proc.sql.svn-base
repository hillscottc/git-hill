CREATE PROCEDURE CTX.TransformLogSessionEnd (@id bigint)
AS
	update CTX.TransformLogSession 
	set EndTime = getdate(), [Status] = 'C'
	where id = @id;