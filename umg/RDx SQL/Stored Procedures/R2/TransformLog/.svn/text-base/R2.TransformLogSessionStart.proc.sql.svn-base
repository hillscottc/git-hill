-- Inserts a record in R2.TransformLogSession
CREATE PROCEDURE R2.TransformLogSessionStart (@logger nvarchar(1000)) 
AS
	declare @sessionID bigint
	select @sessionID = ID from R2.[TransformLogSession] where [Status] = 'P'
	if (@sessionID is null) begin
		
		insert into R2.[TransformLogSession] (Logger) 
		values (@logger) 
		
		set @sessionID = @@identity
	end
	
	RETURN cast(@sessionID as int)
;	
