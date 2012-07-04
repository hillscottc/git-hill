-- Inserts a record in DRA.TransformLogSession
CREATE PROCEDURE DRA.TransformLogSessionStart (@logger nvarchar(1000)) 
AS
	declare @sessionID bigint
	select @sessionID = ID from DRA.[TransformLogSession] where [Status] = 'P'
	if (@sessionID is null) begin
		
		insert into DRA.[TransformLogSession] (Logger) 
		values (@logger) 
		
		set @sessionID = @@identity
	end
	
	RETURN cast(@sessionID as int)
;	
