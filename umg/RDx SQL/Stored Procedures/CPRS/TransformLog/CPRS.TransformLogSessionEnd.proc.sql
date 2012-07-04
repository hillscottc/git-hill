CREATE PROCEDURE CPRS.TransformLogSessionEnd (@id bigint)
AS
	update CPRS.TransformLogSession 
	set EndTime = getdate(), [Status] = 'C'
	where id = @id;