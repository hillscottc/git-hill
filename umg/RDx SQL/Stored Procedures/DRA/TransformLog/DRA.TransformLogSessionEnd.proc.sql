CREATE PROCEDURE DRA.TransformLogSessionEnd (@id bigint)
AS
	update DRA.TransformLogSession 
	set EndTime = getdate(), [Status] = 'C'
	where id = @id;