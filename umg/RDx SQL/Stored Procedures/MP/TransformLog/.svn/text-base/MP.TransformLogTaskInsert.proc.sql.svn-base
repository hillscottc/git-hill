-- Inserts a record in MP.TransformLogTask
-- It will create a pending session in MP.TransformLogSession if there is not one available already 
CREATE PROCEDURE MP.TransformLogTaskInsert (@logger nvarchar(1000), @rows bigint, @workflowCode varchar(2)) 
AS
	declare @sessionID bigint
	select @sessionID = ID from MP.[TransformLogSession] where [Status] = 'P'
	if (@sessionID is null) begin
		
		insert into MP.[TransformLogSession] (Logger) 
		values (@logger) 
		
		set @sessionID = @@identity
	end
	
	INSERT INTO MP.[TransformLogTask] ([SessionID],[Logger],[Rows],[WorkflowCode])
    VALUES (@sessionID, @logger, @rows, @workflowCode)	
;	
