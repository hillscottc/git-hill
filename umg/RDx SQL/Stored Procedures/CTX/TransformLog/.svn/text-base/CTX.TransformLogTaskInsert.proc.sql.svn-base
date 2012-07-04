-- Inserts a record in CTX.TransformLogTask
-- It will create a pending session in CTX.TransformLogSession if there is not one available already 
CREATE PROCEDURE CTX.TransformLogTaskInsert (@logger nvarchar(1000), @rows bigint, @workflowCode varchar(2)) 
AS
	declare @sessionID bigint
	select @sessionID = ID from CTX.[TransformLogSession] where [Status] = 'P'
	if (@sessionID is null) begin
		
		insert into CTX.[TransformLogSession] (Logger) 
		values (@logger) 
		
		set @sessionID = @@identity
	end
	
	INSERT INTO CTX.[TransformLogTask] ([SessionID],[Logger],[Rows],[WorkflowCode])
    VALUES (@sessionID, @logger, @rows, @workflowCode)	
;	
