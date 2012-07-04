-- Inserts a record in CTX.TransformLogSession
CREATE PROCEDURE CTX.TransformLogSessionStart (@logger nvarchar(1000)) 
AS
	declare @sessionID bigint
	select @sessionID = ID from CTX.[TransformLogSession] where [Status] = 'P'
	if (@sessionID is null) begin
		
		insert into CTX.[TransformLogSession] (Logger) 
		values (@logger) 
		
		set @sessionID = @@identity
	end
	
	RETURN cast(@sessionID as int)
;	
