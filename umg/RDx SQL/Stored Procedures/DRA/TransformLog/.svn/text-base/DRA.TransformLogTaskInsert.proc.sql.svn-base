-- Inserts a record in DRA.TransformLogTask
-- It will create a pending session in DRA.TransformLogSession if there is not one available already 
CREATE PROCEDURE DRA.TransformLogTaskInsert (@logger nvarchar(1000), @rows bigint, @workflowCode varchar(2)) 
AS
	declare @sessionID bigint
	select @sessionID = ID from DRA.[TransformLogSession] where [Status] = 'P'
	if (@sessionID is null) begin
		
		insert into DRA.[TransformLogSession] (Logger) 
		values (@logger) 
		
		set @sessionID = @@identity
	end
	
	INSERT INTO DRA.[TransformLogTask] ([SessionID],[Logger],[Rows],[WorkflowCode])
    VALUES (@sessionID, @logger, @rows, @workflowCode)	
;	
