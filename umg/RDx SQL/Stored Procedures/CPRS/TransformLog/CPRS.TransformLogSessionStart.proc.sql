-- Inserts a record in CPRS.TransformLogSession
CREATE PROCEDURE CPRS.TransformLogSessionStart (@logger nvarchar(1000)) 
AS
	declare @sessionID bigint
	select @sessionID = ID from CPRS.[TransformLogSession] where [Status] = 'P'
	if (@sessionID is null) begin
		
		insert into CPRS.[TransformLogSession] (Logger) 
		values (@logger) 
		
		set @sessionID = @@identity
	end
	
	RETURN cast(@sessionID as int)
;	
