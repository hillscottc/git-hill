-- Inserts a record in MP.TransformLogSession
CREATE PROCEDURE MP.TransformLogSessionStart (@logger nvarchar(1000)) 
AS
	declare @sessionID bigint
	select @sessionID = ID from MP.[TransformLogSession] where [Status] = 'P'
	if (@sessionID is null) begin
		
		insert into MP.[TransformLogSession] (Logger) 
		values (@logger) 
		
		set @sessionID = @@identity
	end
	
	RETURN cast(@sessionID as int)
;	
